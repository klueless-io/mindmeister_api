# frozen_string_literal: true

# Mind map node
module MindmeisterApi
  class Node
    attr_accessor :level

    attr_accessor :id
    attr_accessor :title
    attr_accessor :rank
    attr_accessor :pos
    attr_accessor :floating
    attr_accessor :icon
    attr_accessor :style
    attr_accessor :created_at
    attr_accessor :updated_at
    attr_accessor :note
    attr_accessor :link
    attr_accessor :task
    attr_accessor :attachments
    attr_accessor :image

    attr_accessor :children
    attr_accessor :boundary
    attr_accessor :video
  end
end
