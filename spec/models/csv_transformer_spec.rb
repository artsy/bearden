require 'rails_helper'

describe CsvTransformer do
  describe 'transform' do
    it 'returns attrs for an Organization' do
      data = {
        address: '123 Main Street',
        city: 'New York',
        country: 'USA',
        latitude: '47.5543105',
        longitude: '7.598538899999999',
        organization_name: 'Best Gallery',
        postal_code: '22021',
        state: 'NY',
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
          address1: data[:address],
          country: data[:country],
          lat: data[:latitude],
          lng: data[:longitude],
          locality: data[:city],
          postcode: data[:postal_code],
          region: data[:state]
        }
      }
      expect(attrs).to eq(expected)
    end
  end
end
