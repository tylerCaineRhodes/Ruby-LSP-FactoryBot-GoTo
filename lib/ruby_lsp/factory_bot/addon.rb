# frozen_string_literal: true

require 'ruby-lsp'
require 'ruby_lsp/addon'
require_relative 'factory_index'
require_relative 'definition_listener'

module RubyLsp
  module FactoryBot
    # Ruby LSP addon that provides "Go to Definition" for FactoryBot factory references.
    # Indexes all factories in spec/factories/**/*.rb and enables jumping to factory definitions
    # from calls like create(:factory_name), build(:factory_name), etc.
    class Addon < ::RubyLsp::Addon
      def initialize
        super
        @factory_index = FactoryIndex.new
      end

      def activate(global_state, _outgoing_queue)
        workspace_root = global_state&.workspace_path || Dir.pwd
        @factory_index.rebuild!(workspace_root)
      end

      def name
        'Ruby LSP FactoryBot'
      end

      def version
        '0.1.0'
      end

      def create_definition_listener(response_builder, _uri, node_context, dispatcher)
        DefinitionListener.new(response_builder, node_context, @factory_index, dispatcher)
      end

      def deactivate; end
    end
  end
end
