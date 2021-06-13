# frozen_string_literal: true

module MindmeisterApi
  # Parse a Mindmeister .mind formatted content
  class MindmeisterMapParser
    include KLog::Logging

    attr_reader :input_mindmap
    attr_reader :mindmap

    # Create a parser for a mindmeister mindmap
    #
    # @param [Hash] input_mindmap Mindmeister formatted object
    def initialize(input_mindmap)
      @input_mindmap = input_mindmap
    end

    class << self
      # Factory for creating a parser for an existing mindmap .json file
      def json_file_parser(json_file)
        raise MindmeisterApi::Error, "File not found: #{json_file}" unless File.exist?(json_file)

        content = File.read(json_file)
        json = JSON.parse(content)
        new(json)
      end
    end

    def valid?
      return false if input_mindmap.nil? || input_mindmap == {}
      return false unless input_mindmap['root'] && input_mindmap['root']['id']

      true
    end

    def parse
      @mindmap = parse_node(input_mindmap['root'], 1) if valid?

      self
    end

    private

    # rubocop:disable Metrics/AbcSize
    def parse_node(input_node, level)
      node = Node.new

      node.level        = level

      node.id           = input_node['id']                  # DONE:
      node.title        = input_node['title']               # DONE:
      node.rank         = input_node['rank']                # TODO: waiting for a value to reveal itself
      node.pos          = input_node['pos']                 # TODO: waiting for a value to reveal itself
      node.floating     = input_node['floating']            # TODO: waiting for a value to reveal itself
      node.icon         = input_node['icon']                # TODO: waiting for a value to reveal itself
      node.style        = input_node['style']               # TODO: waiting for a value to reveal itself
      node.created_at   = input_node['created_at']          # TODO: Map to date time
      node.updated_at   = input_node['updated_at']          # TODO: Map to date time
      node.note         = input_node['note']                # TODO: waiting for a value to reveal itself
      node.link         = input_node['link']                # TODO: waiting for a value to reveal itself
      node.task         = input_node['task']                # TODO: Link to task
      node.attachments  = input_node['attachments']         # TODO: Array
      node.image        = input_node['image']               # TODO: ?
      node.boundary     = input_node['boundary']            # TODO: ?
      node.video        = input_node['video']               # TODO: ?

      node.children     = input_node['children'].map { |child| parse_node(child, level + 1) } if input_node['children']

      node
    end
    # rubocop:enable Metrics/AbcSize
  end
end
