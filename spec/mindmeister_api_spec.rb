# frozen_string_literal: true

RSpec.describe MindmeisterApi do
  it 'has a version number' do
    expect(MindmeisterApi::VERSION).not_to be nil
  end

  it 'personal access token is in environment' do
    expect(ENV['MINDMEISTER_PAT']).not_to be_nil
  end

  # it 'details about me' do
  #   json = get_me

  #   puts JSON.pretty_generate(json)
  # end

  # it 'details about a map' do
  #   json = get_map('1923180718')

  #   puts JSON.pretty_generate(json)
  # end

  # it 'uncompress .mind' do
  #   path = 'sample_maps'
  #   source = File.join(path, 'Print_Speak_Architecture.mind')
  #   target = File.join(path, 'map2.json')

  #   uncompress(source, target)
  # end

  # rubocop:disable Naming/AccessorMethodName
  def get_me
    mindmeister_get(end_point: 'api/v2/users/me')
  end

  def get_map(id)
    mindmeister_get(end_point: "api/v2/maps/#{id}")
  end

  def get_mindmeister_map(id)
    mindmeister_get(end_point: "api/v2/maps/#{id}.mind")
  end

  # rubocop:enable Naming/AccessorMethodName

  def mindmeister_get(end_point:)
    response = mindmeister_request_response(end_point)
    mindmeister_handle_response(response)
  end

  def personal_access_token
    @personal_access_token ||= ENV['MINDMEISTER_PAT']
  end

  def mindmeister_request_response(end_point)
    host = 'https://www.mindmeister.com'
    api_url = "#{host}/#{end_point}"

    uri = URI.parse(api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = "Bearer #{personal_access_token}"
    http.request(request)
  end

  def mindmeister_handle_response(response)
    json = {}
    json = JSON.parse(response.body) if response.code == '200'
    json
  end

  # MAX_SIZE = 50 * (1024**2) # 1 MegaBytes

  def uncompress(source, target)
    # MAX_SIZE = 50 * (1024**2)
    Zip::File.open(source) do |zip_file|
      # # Handle entries one by one
      # zip_file.each do |entry|
      #   puts "Extracting #{entry.name}"
      #   raise 'File too large when extracted' if entry.size > MAX_SIZE

      #   # Extract to file or directory based on name in the archive
      #   # entry.extract

      #   # Read into memory
      #   content = entry.get_input_stream.read
      #   # puts content
      # end

      # # Find specific entry
      entry = zip_file.glob('map.json').first

      File.write(target, entry.get_input_stream.read) if entry
    end
  end
end
