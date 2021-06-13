# frozen_string_literal: true

require 'json'
require 'net/http'
require 'zip'

require_relative 'mindmeister_api/version'
# require_relative 'mindmeister_api/printer/'
require_relative 'mindmeister_api/mindmeister_map_parser'
require_relative 'mindmeister_api/models/node'

module MindmeisterApi
  class Error < StandardError; end
  # Your code goes here...
end
