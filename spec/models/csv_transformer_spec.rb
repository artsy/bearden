require 'rails_helper'

describe CsvTransformer do
  describe 'transform' do
    context 'with no fields' do
      it 'returns an empty hash' do
        data = {
          city: '',
          country: '',
          email: '',
          in_business: nil,
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

    context 'with partial fields' do
      it 'returns only those fields that are not empty' do
        data = {
          email: 'info@example.com',
          organization_name: 'Best Gallery',
          phone_number: '1-800-123-4567',
          website: 'http://example.com'
        }
        raw_input = Fabricate :raw_input, data: data
        attrs = CsvTransformer.transform raw_input
        expected = {
          email: {
            content: data[:email]
          },
          organization_name: {
            content: data[:organization_name]
          },
          phone_number: {
            content: data[:phone_number]
          },
          website: {
            content: data[:website]
          }
        }
        expect(attrs).to eq(expected)
      end

      it 'returns a clean list of tag names from a messy list' do
        data = {
          tag_names: ', design, modern , '
        }
        raw_input = Fabricate :raw_input, data: data
        attrs = CsvTransformer.transform raw_input
        expected = {
          tag_names: %w[design modern]
        }
        expect(attrs).to eq(expected)
      end
    end

    context 'with sparse fields' do
      it 'returns only those fields that are not empty' do
        data = {
          city: 'Berlin',
          country: '',
          email: '',
          location: '123 Main Street, New York, NY 10001',
          latitude: '47.5543105',
          longitude: '7.598538899999999',
          organization_name: '',
          phone_number: '',
          tag_names: '',
          website: 'http://example.com'
        }
        raw_input = Fabricate :raw_input, data: data
        attrs = CsvTransformer.transform raw_input
        expected = {
          location: {
            city: data[:city],
            content: data[:location],
            latitude: data[:latitude],
            longitude: data[:longitude]
          },
          website: {
            content: data[:website]
          }
        }
        expect(attrs).to eq(expected)
      end
    end

    context 'with complete fields' do
      it "returns all attrs for an Organization and it's relationships" do
        data = {
          city: 'Vaughn',
          country: 'Key Peninsula',
          email: 'info@example.com',
          in_business: false,
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
            city: data[:city],
            country: data[:country],
            content: data[:location],
            latitude: data[:latitude],
            longitude: data[:longitude]
          },
          organization: {
            in_business: false
          },
          organization_name: {
            content: data[:organization_name]
          },
          phone_number: {
            content: data[:phone_number]
          },
          tag_names: %w[design modern],
          website: {
            content: data[:website]
          }
        }
        expect(attrs).to eq(expected)
      end
    end

    context 'with bonus fields' do
      it 'returns a hash that ignores those fields' do
        data = {
          emmmmail: 'info@example.com',
          omglol: 'hahaha',
          organization_name: 'Best Gallery',
          phone_number: '1-800-123-4567',
          website: 'http://example.com'
        }
        raw_input = Fabricate :raw_input, data: data
        attrs = CsvTransformer.transform raw_input
        expected = {
          organization_name: {
            content: data[:organization_name]
          },
          phone_number: {
            content: data[:phone_number]
          },
          website: {
            content: data[:website]
          }
        }
        expect(attrs).to eq(expected)
      end
    end
  end
end
