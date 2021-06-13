# frozen_string_literal: true

module MindmeisterApi
  # Enumerate through the mind map hierarchy to build a list of nodes
  class NodeEnumerator
    include KLog::Logging

    attr_reader :list

    def initialize(mindmap)
      @list = []

      add_node(mindmap)
    end

    private

    def add_node(current_node)
      node = current_node.clone
      node.children = nil

      @list << node

      current_node.children.each do |child_node|
        add_node(child_node)
      end
    end
  end
end
