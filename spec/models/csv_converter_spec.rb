require 'rails_helper'

describe CsvConverter do
  describe '.convert' do
    it 'returns the converted data' do
      input = {
        bearden_id: 1,
        city: 'New York',
        country: 'USA',
        email: 'info@example.com',
        latitude: 2.234,
        location: '123 main street',
        longitude: 3.45,
        organization_name: 'Gallery A',
        phone_number: '1-800-123-4567',
        tag_names: 'design,modern',
        website: 'http://example.com',
        sources: 'ArtMagazine,SpiderMania'
      }

      converted = CsvConverter.convert input

      expect(converted).to eq input.values
    end
  end
end
