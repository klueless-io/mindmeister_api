# frozen_string_literal: true

RSpec.describe MindmeisterApi::MindmeisterMapParser do
  let(:valid_mindmap_file) { 'sample_maps/map.json' }
  let(:invalid_mindmap_file) { 'sample_maps/invalid_map.json' }
  let(:valid_simple_mindmap_file) { 'sample_maps/map_simple.json' }

  let(:file) { valid_mindmap_file }

  describe 'constructor' do
    subject { described_class.new({}) }

    it { is_expected.not_to be_nil }

    describe '.valid?' do
      subject { described_class.new(input_mindmap).valid? }

      context 'when input json is valid' do
        let(:input_mindmap) { { 'root' => { 'id' => '123' } } }

        it { is_expected.to be_truthy }
      end

      context 'when input json is empty' do
        let(:input_mindmap) { {} }

        it { is_expected.to be_falsey }
      end

      context 'when input json is invalid' do
        let(:input_mindmap) { { 'thunderbirds' => 'are go' } }

        it { is_expected.to be_falsey }
      end
    end
  end

  describe 'factory' do
    describe '#json_file_parser' do
      subject { described_class.json_file_parser(file) }

      context 'when file not found' do
        let(:file) { 'bad_file' }

        it { expect { subject }.to raise_error(MindmeisterApi::Error, 'File not found: bad_file') }
      end

      describe '.valid?' do
        subject { described_class.json_file_parser(file).valid? }

        context 'when file provided with invalid format' do
          let(:file) { invalid_mindmap_file }

          it { is_expected.to be_falsey }
        end

        context 'when file provided with valid format' do
          let(:file) { valid_mindmap_file }

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  describe '#parse' do
    let(:instance) { described_class.json_file_parser(file).parse }

    describe '.mindmap' do
      subject { instance.mindmap }

      context 'when file provided with invalid format' do
        let(:file) { invalid_mindmap_file }

        it { is_expected.to be_nil }
      end

      context 'when file provided with valid format' do
        let(:file) { valid_mindmap_file }

        it { is_expected.not_to be_nil }
      end
    end
  end

  describe '#parse -> mappings' do
    subject { instance.mindmap }

    let(:instance) { described_class.json_file_parser(file) }
    let(:file) { valid_simple_mindmap_file }

    before { instance.parse }

    context 'root mapping' do
      it do
        is_expected.to have_attributes(
          id: a_value,
          title: a_string_starting_with('Architecture'),
          pos: match_array([nil, nil])
        )
      end

      describe '.children' do
        subject { instance.mindmap.children }

        it { is_expected.not_to be_nil }
        it { is_expected.to have_attributes(length: 2) }

        describe 'child[0]' do
          subject { instance.mindmap.children[0] }

          it { is_expected.to have_attributes(id: a_value, title: 'Goal', children: have_attributes(length: 3)) }
        end

        describe 'child[1]' do
          subject { instance.mindmap.children[1] }

          it { is_expected.to have_attributes(id: a_value, title: 'Observations', children: have_attributes(length: 2)) }
        end
      end
    end
  end

  describe '.node_list' do
    subject { described_class.json_file_parser(file).parse.node_list }

    let(:file) { valid_simple_mindmap_file }

    # subject.map { |r| "#{' ' * (r.level*2)} - #{r.title}" }

    # describe '.valid?' do
    #   subject { described_class.json_file_parser(file).valid? }

    #   context 'when file provided with invalid format' do
    #     let(:file) { invalid_mindmap_file }

    #     it { is_expected.to be_falsey }
    #   end

    #   context 'when file provided with valid format' do
    #     let(:file) { valid_mindmap_file }

    #     it { is_expected.to be_truthy }
    #   end
    # end
  end
end
