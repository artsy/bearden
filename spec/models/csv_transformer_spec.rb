require 'rails_helper'

describe CsvTransformer do
  describe 'transform' do
    it 'returns attrs for an Organization' do
      data = {
        location: '123 Main Street, New York, NY 10001',
        latitude: '47.5543105',
        longitude: '7.598538899999999',
        organization_name: 'Best Gallery',
        tag_names: 'design,modern',
        website: 'http://example.com'
      }
      raw_input = Fabricate :raw_input, data: data
      attrs = CsvTransformer.transform raw_input
      expected = {
        location: {
          content: data[:location],
          latitude: data[:latitude],
          longitude: data[:longitude]
        },
        organization_name: {
          content: data[:organization_name]
        },
        tag_names: %w(design modern),
        website: {
          content: data[:website]
        }
      }
      expect(attrs).to eq(expected)
    end
  end
end
