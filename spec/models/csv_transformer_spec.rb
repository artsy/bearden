require 'rails_helper'

describe CsvTransformer do
  describe 'transform' do
    it 'returns attrs for an Organization' do
      data = {
        location: '123 Main Street, New York, NY 10001',
        latitude: '47.5543105',
        longitude: '7.598538899999999',
        organization_name: 'Best Gallery',
        website: 'http://example.com'
      }
      raw_input = Fabricate :raw_input, data: data
      attrs = CsvTransformer.transform raw_input
      expected = {
        organization_name: {
          content: data[:organization_name]
        },
        website: {
          content: data[:website]
        },
        location: {
          content: data[:location],
          latitude: data[:latitude],
          longitude: data[:longitude]
        }
      }
      expect(attrs).to eq(expected)
    end
  end
end
