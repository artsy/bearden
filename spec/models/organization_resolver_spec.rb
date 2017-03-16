require 'rails_helper'

describe OrganizationResolver do
  describe '.resolve' do
    context 'with no related data' do
      it 'returns only the organization id' do
        organization = Fabricate :organization
        resolved = OrganizationResolver.resolve organization
        expect(resolved).to eq(
          {
            bearden_id: organization.id,
            tag_names: ''
          }
        )
      end
    end

    context 'with one set of data' do
      it 'returns all resolved data' do
        source = Fabricate :source
        import = Fabricate :import, source: source
        raw_input = Fabricate :raw_input, import: import

        organization = nil
        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        tag_names = 'design,modern'
        website = 'http://www.example.com'

        PaperTrail.track_changes_with(raw_input) do
          organization = Fabricate :organization
          Fabricate(:location,
                    organization: organization,
                    content: location,
                    latitude: latitude,
                    longitude: longitude)
          Fabricate(:organization_name,
                    organization: organization,
                    content: organization_name)
          tag_names.split(',').each do |tag_name|
            tag = Fabricate :tag, name: tag_name
            Fabricate :organization_tag, organization: organization, tag: tag
          end
          Fabricate :website, organization: organization, content: website
        end

        resolved = OrganizationResolver.resolve organization

        expect(resolved).to eq(
          {
            bearden_id: organization.id,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            tag_names: tag_names,
            website: website
          }
        )
      end
    end

    context 'with two sets of data' do
      it 'returns only the highest ranked data' do
        organization = nil

        lower_source = Fabricate :source, rank: 2
        lower_import = Fabricate :import, source: lower_source
        lower_raw_input = Fabricate :raw_input, import: lower_import
        lower_tag_name = 'modern'

        PaperTrail.track_changes_with(lower_raw_input) do
          organization = Fabricate :organization
          Fabricate :location, organization: organization
          Fabricate :organization_name, organization: organization
          tag = Fabricate :tag, name: lower_tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization
        end

        higher_source = Fabricate :source, rank: 1
        import = Fabricate :import, source: higher_source
        raw_input = Fabricate :raw_input, import: import

        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        tag_name = 'design'
        website = 'http://www.example.com'

        PaperTrail.track_changes_with(raw_input) do
          Fabricate(:location,
                    organization: organization,
                    content: location,
                    latitude: latitude,
                    longitude: longitude)
          Fabricate(:organization_name,
                    organization: organization,
                    content: organization_name)
          tag = Fabricate :tag, name: tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization, content: website
        end

        resolved = OrganizationResolver.resolve organization

        expect(resolved).to eq(
          {
            bearden_id: organization.id,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            tag_names: [lower_tag_name, tag_name].join(','),
            website: website
          }
        )
      end
    end
  end
end
