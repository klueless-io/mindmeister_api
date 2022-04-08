# frozen_string_literal: true

RSpec.describe MindmeisterApi do
  include MindmeisterApi::Printer

  it 'has a version number' do
    expect(MindmeisterApi::VERSION).not_to be nil
  end

  it 'personal access token is in environment' do
    expect(ENV['MINDMEISTER_PAT']).not_to be_nil
  end

  it 'details about me' do
    json = get_me

    puts JSON.pretty_generate(json)
  end

  it 'details about a map' do
    json = get_map('1923180718')

    puts JSON.pretty_generate(json)
  end

  it 'details about a map in mindmeister format' do
    content_list = get_mindmeister_map('1923180718')

    json_content = content_list.find_content('map.json')

    if json_content
      path = 'sample_maps'
      File.write(File.join(path, 'map3.json'), json_content)

      json = JSON.parse(json_content)
      parser = MindmeisterApi::MindmeisterMapParser.new(json)
      parser.parse

      print_mindmap(parser.mindmap, take: 40)
    end
  end

  it 'law of demeter' do
    get_and_print_mindmap('1930722860', 'map-law_of_demeter.json')
  end

  fit 'printspeak architecture and test slides' do
    get_and_print_mindmap('1923180718', 'printspeak-architecture.json')
  end

  # path = 'sample_maps'
  # target = File.join(path, 'map3.json')

  it 'uncompress .mind' do
    path = 'sample_maps'
    source_file = File.join(path, 'Print_Speak_Architecture.mind')

    content_list = MindmeisterApi.zip.uncompress_file(source_file)

    json_content = content_list.find_content('map.json')

    File.write(File.join(path, 'map2.json'), json_content) if json_content
  end

  def get_and_print_mindmap(id, outputfile)
    content_list = get_mindmeister_map(id)

    json_content = content_list.find_content('map.json')

    if json_content
      path = 'sample_maps'
      File.write(File.join(path, outputfile), json_content)

      json = JSON.parse(json_content)
      parser = MindmeisterApi::MindmeisterMapParser.new(json)
      parser.parse

      print_mindmap(parser.mindmap, take: nil)
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_me
    mindmeister_get(end_point: 'api/v2/users/me')
  end

  def get_map(id)
    mindmeister_get(end_point: "api/v2/maps/#{id}")
  end

  def get_mindmeister_map(id)
    response = mindmeister_request_response("api/v2/maps/#{id}.mind")

    if response.code == '200'
      MindmeisterApi.zip.uncompress_content(response.body)
    else
      MindmeisterApi::ZipContentList.new
    end
  end

  # rubocop:enable Naming/AccessorMethodName
  def mindmeister_get(end_point:)
    response = mindmeister_request_response(end_point)

    parse_json(response)
  end

  def personal_access_token
    # @personal_access_token ||=  "7639aa7d92f49e567f7062476d44b2c6c0ac7a94a5fcf8e4cd366877b22db360" # ENV['MINDMEISTER_PAT']
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

  def parse_json(response)
    json = {}
    json = JSON.parse(response.body) if response.code == '200'
    json
  end
end
