# frozen_string_literal: true

RSpec.describe MindmeisterApi::NodeEnumerator do
  let(:valid_mindmap_file) { 'sample_maps/map.json' }
  let(:invalid_mindmap_file) { 'sample_maps/invalid_map.json' }
  let(:valid_simple_mindmap_file) { 'sample_maps/map_simple.json' }

  let(:file) { valid_simple_mindmap_file }

  let(:parser) { MindmeisterApi::MindmeisterMapParser.json_file_parser(file) }
  let(:mindmap) { parser.parse.mindmap }

  describe '.list' do
    subject { described_class.new(mindmap).list }

    context 'when file provided with invalid format' do
      it { is_expected.to have_attributes(length: 8) }
    end
  end
end
