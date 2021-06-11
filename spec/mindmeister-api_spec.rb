# frozen_string_literal: true

RSpec.describe MindmeisterApi do
  it 'has a version number' do
    expect(MindmeisterApi::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise MindmeisterApi::Error, 'some message' }
      .to raise_error('some message')
  end
end
