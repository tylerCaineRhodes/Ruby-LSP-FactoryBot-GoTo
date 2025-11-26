# frozen_string_literal: true

require 'ruby_lsp/requests/support/common'
require 'language_server/protocol/interface'

module RubyLsp
  module FactoryBot
    class DefinitionListener
      include ::RubyLsp::Requests::Support::Common

      FACTORY_METHODS = %i[create build build_list create_list attributes_for].freeze

      def initialize(response_builder, node_context, factory_index, dispatcher)
        @response_builder = response_builder
        @node_context = node_context
        @factory_index = factory_index

        dispatcher.register(self, :on_symbol_node_enter, :on_string_node_enter)
      end

      def on_symbol_node_enter(node)
        handle_factory_reference(node.value)
      end

      def on_string_node_enter(node)
        handle_factory_reference(node.content)
      end

      private

      def handle_factory_reference(factory_name)
        call = @node_context.call_node
        return unless call && FACTORY_METHODS.include?(call.name)

        entry = @factory_index.lookup(factory_name)
        return unless entry

        @response_builder << location_from_entry(entry)
      end

      def location_from_entry(entry)
        LanguageServer::Protocol::Interface::Location.new(
          uri:   entry.uri,
          range: range_from_location(entry.location)
        )
      end

      def range_from_location(location)
        LanguageServer::Protocol::Interface::Range.new(
          start: position_from_line_column(location.start_line, location.start_column),
          end:   position_from_line_column(location.end_line, location.end_column)
        )
      end

      def position_from_line_column(line, column)
        LanguageServer::Protocol::Interface::Position.new(
          line:      line - 1,
          character: column
        )
      end
    end
  end
end
