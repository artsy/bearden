require 'rails_helper'

describe CsvConverter do
  describe '.convert' do
    it 'returns the converted data' do
      input = {
        bearden_id: 1,
        latitude: 2.234,
        location: '123 main street',
        longitude: 3.45,
        organization_name: 'Gallery A',
        tag_names: 'design,modern',
        website: 'http://example.com'
      }

      converted = CsvConverter.convert input

      expect(converted).to eq input.values
    end
  end
end
