# frozen_string_literal: true

# Print helpers for mind map node
module MindmeisterApi
  # Include the Printer namespace to have access to console printers
  module Printer
    include KLog::Logging

    def print_mindmap(mindmap, take: nil)
      list = NodeEnumerator.new(mindmap).list
      list = list.take(take) if take

      print_nodes_as_table(list)
    end

    def print_nodes_as_table(nodes)
      log.section_heading 'Mindmap'

      tp nodes,
        :id,
        :level,
        { title: { width: 50, display_method: ->(row) { "#{' ' * ((row.level - 1) * 2)}#{row.title.gsub("\r", ' ')}" } } },
        :rank,
        { pos: { display_method: ->(row) { row.pos.nil? ? '' : "#{row.pos.reject(&:nil?).join(',')}" } } },
        :floating,
        { icon: { display_method: ->(row) { row.icon.nil? ? '' : "#{row.icon.reject(&:nil?).join(',')}" } } },
        :style,
        :note,
        :link,
        :task,
        :attachments,
        :image,
        :boundary,
        :video
    end
  end
end
