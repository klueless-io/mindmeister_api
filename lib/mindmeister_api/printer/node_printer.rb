# frozen_string_literal: true

# Print helpers for mind map node
module MindmeisterApi
  # Include the Printer namespace to have access to console printers
  module Printer
    def print_nodes(rows = nil, format: :default)
      log.section_heading 'Nodes'

      rows = Node.unscoped.all if rows.nil?

      rows.each do |row|
        print_node_detailed(row) if format == :detailed
        print_node(row) if format == :default
      end
    end
    alias print_default_nodes print_nodes

    def print_nodes_as_table(rows = nil, format: :default)
      log.section_heading 'Nodes'

      rows = Node.unscoped.all if rows.nil?

      tp rows, :id, :name, :node_type, :default, 'enterprise.name'
    end
    alias print_default_nodes_as_table print_nodes_as_table

    # rubocop:disable Metrics/AbcSize
    def print_node(row)
      log.kv 'id', row.id
      log.kv 'name', row.name
      log.kv 'node_type', row.node_type
      log.kv 'default', row.default

      # Belongs to relationships
      log.kv 'enterprise > name', row.enterprise.name if row.enterprise&.name

      log.line
    end

    def print_node_detailed(row)
      log.kv 'id', row.id
      log.kv 'name', row.name
      log.kv 'node_type', row.node_type
      log.kv 'created_at', row.created_at
      log.kv 'updated_at', row.updated_at
      log.kv 'default', row.default
      log.kv 'enterprise_id', row.enterprise_id

      # Belongs to relationships
      log.kv 'enterprise > name', row.enterprise.name if row.enterprise&.name

      log.line
    end
    # rubocop:enable Metrics/AbcSize
  end
end
