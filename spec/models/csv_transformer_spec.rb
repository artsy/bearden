require 'rails_helper'

describe CsvTransformer do
  describe 'transform' do
    it 'returns attrs for an Organization' do
      data = {
        address: '123 Main Street',
        city: 'New York',
        country: 'USA',
        host: 'http://example.com',
        latitude: '47.5543105',
        longitude: '7.598538899999999',
        postal_code: '22021',
        state: 'NY'
      }
      raw_input = Fabricate :raw_input, data: data
      attrs = CsvTransformer.transform raw_input
      expected = {
        organization: {
          website: data[:host]
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
