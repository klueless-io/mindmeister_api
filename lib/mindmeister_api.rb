# frozen_string_literal: true

require 'json'
require 'net/http'
require 'zip'
require 'k_log'

require_relative 'mindmeister_api/version'
require_relative 'mindmeister_api/printer/node_printer'
require_relative 'mindmeister_api/mindmeister_map_parser'
require_relative 'mindmeister_api/models/node'
require_relative 'mindmeister_api/models/node_enumerator'
require_relative 'mindmeister_api/zip_helpers/zip_content_list'
require_relative 'mindmeister_api/zip_helpers/zip_helper'

# Mindmeister API
module MindmeisterApi
  # Mindmeister Errors
  class Error < StandardError; end

  # Static helpers
  class << self
    def zip
      @zip ||= MindmeisterApi::ZipHelper.new
    end
  end
end
