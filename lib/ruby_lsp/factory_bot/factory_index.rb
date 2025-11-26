# frozen_string_literal: true

require 'uri'
require 'prism'

module RubyLsp
  module FactoryBot
    class FactoryIndex
      Entry = Struct.new(:uri, :location)

      def initialize
        @mutex = Mutex.new
        @entries = {}
      end

      def rebuild!(workspace_root)
        new_entries = {}
        factory_pattern = File.join(workspace_root, 'spec', 'factories', '**', '*.rb')

        Dir.glob(factory_pattern).each do |path|
          parse_factory_file(path, new_entries)
        end

        @mutex.synchronize { @entries = new_entries }
      end

      def lookup(name)
        @mutex.synchronize { @entries[name.to_s] }
      end

      private

      def parse_factory_file(path, entries)
        source = File.read(path)
        ast = Prism.parse(source)
        uri = URI("file://#{path}").to_s

        index_factories(ast.value, uri, entries)
      end

      def index_factories(node, uri, entries)
        return unless node.respond_to?(:child_nodes)

        node.child_nodes.each do |child|
          next unless child

          if factory_definition?(child)
            extract_factory_names(child).each do |name, location|
              entries[name] = Entry.new(uri, location)
            end
          end

          index_factories(child, uri, entries)
        end
      end

      def factory_definition?(node)
        node.is_a?(Prism::CallNode) &&
          node.name == :factory &&
          node.arguments&.arguments&.first.is_a?(Prism::SymbolNode)
      end

      def extract_factory_names(node)
        args = node.arguments.arguments
        primary_name = args.first
        location = primary_name.location

        names = [[primary_name.value.to_s, location]]

        # Add aliases if present
        extract_aliases(args).each do |alias_name|
          names << [alias_name, location]
        end

        names
      end

      def extract_aliases(args)
        keyword_hash = args.find { |arg| arg.is_a?(Prism::KeywordHashNode) }
        return [] unless keyword_hash

        aliases_assoc =
          keyword_hash.elements.find do |el|
            el.is_a?(Prism::AssocNode) &&
              el.key.is_a?(Prism::SymbolNode) &&
              el.key.value.to_s == 'aliases'
          end

        return [] unless aliases_assoc

        array_value = aliases_assoc.value
        return [] unless array_value.is_a?(Prism::ArrayNode)

        array_value.elements.filter_map do |element|
          case element
          when Prism::SymbolNode then element.value.to_s
          when Prism::StringNode then element.content
          end
        end
      end
    end
  end
end
