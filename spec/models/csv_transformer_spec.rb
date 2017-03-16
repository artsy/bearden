require 'rails_helper'

describe CsvTransformer do
  describe 'transform' do
    context 'with no fields' do
      it 'returns an empty hash' do
        data = {
          email: '',
          location: '',
          latitude: '',
          longitude: '',
          organization_name: '',
          phone_number: '',
          tag_names: '',
          website: ''
        }
        raw_input = Fabricate :raw_input, data: data
        attrs = CsvTransformer.transform raw_input
        expect(attrs).to eq({})
      end
    end

    context 'with all fields' do
      it 'returns attrs for an Organization' do
        data = {
          email: 'info@example.com',
          location: '123 Main Street, New York, NY 10001',
          latitude: '47.5543105',
          longitude: '7.598538899999999',
          organization_name: 'Best Gallery',
          phone_number: '1-800-123-4567',
          tag_names: 'design,modern',
          website: 'http://example.com'
        }
        raw_input = Fabricate :raw_input, data: data
        attrs = CsvTransformer.transform raw_input
        expected = {
          email: {
            content: data[:email]
          },
          location: {
            content: data[:location],
            latitude: data[:latitude],
            longitude: data[:longitude]
          },
          organization_name: {
            content: data[:organization_name]
          },
          phone_number: {
            content: data[:phone_number]
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
end
