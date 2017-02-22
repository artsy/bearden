require 'rails_helper'

describe RawInputTransformJob do
  describe '#perform' do
    context 'with a new record' do
      it 'creates that record and records the result' do
        source = Fabricate :source, name: 'rake'
        import = Fabricate(:import,
                           source: source,
                           transformer: CsvImportTransformer)
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
        raw_input = Fabricate :raw_input, import: import, data: data
        RawInputTransformJob.new.perform raw_input.id

        expect(Organization.count).to eq 1
        organization = Organization.first
        expect(organization.versions.first.actor).to eq raw_input
        expect(Location.count).to eq 1
        location = Location.first
        expect(location.versions.first.actor).to eq raw_input
        expect(raw_input.reload.output_id).to eq organization.id
        expect(raw_input.output_type).to eq organization.class.to_s
        expect(raw_input.result).to eq 'created'

        expect(PaperTrail.whodunnit).to eq 'Test User'
      end
    end
  end
end
