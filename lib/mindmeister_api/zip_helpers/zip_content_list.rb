# frozen_string_literal: true

module MindmeisterApi
  # ZIP helper
  class ZipContentList
    attr_reader :list

    def initialize
      @list = []
    end

    def add(name, content)
      @list << OpenStruct.new(name: name, content: content)
    end

    def find(name)
      @list.find { |item| item.name == name }
    end

    def find_content(name)
      item = find(name)

      item.nil? ? nil : item.content
    end
  end
end
