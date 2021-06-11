# frozen_string_literal: true

require 'mindmeister-api/version'

module MindmeisterApi
  # raise MindmeisterApi::Error, 'Sample message'
  class Error < StandardError; end

  # Your code goes here...
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'MindmeisterApi::Version'
  file_path =
    $LOADED_FEATURES.find { |f| f.include?('mindmeister-api/version') }
  version = MindmeisterApi::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
