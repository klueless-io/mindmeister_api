# frozen_string_literal: true

RSpec.describe 'MindmeisterApi::Printer' do
  include MindmeisterApi::Printer

  let(:valid_mindmap_file) { 'sample_maps/map.json' }
  let(:invalid_mindmap_file) { 'sample_maps/invalid_map.json' }
  let(:valid_simple_mindmap_file) { 'sample_maps/map_simple.json' }

  let(:file) { valid_mindmap_file }

  let(:parser) { MindmeisterApi::MindmeisterMapParser.json_file_parser(file) }
  let(:mindmap) { parser.parse.mindmap }

  describe '#node_printer' do
    subject { print_mindmap(mindmap, take: 50) }

    it { subject }
  end
end
