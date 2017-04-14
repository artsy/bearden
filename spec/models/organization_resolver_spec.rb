require 'rails_helper'

describe OrganizationResolver do
  describe '.resolve' do
    context 'with no related data' do
      it 'returns only the organization id' do
        source = Fabricate :source
        import = Fabricate :import, source: source
        raw_input = Fabricate :raw_input, import: import
        organization = nil

        PaperTrail.track_changes_with(raw_input) do
          organization = Fabricate :organization
        end

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
        city = 'Paris'
        country = 'France'
        email = 'info@example.com'
        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        phone_number = '1-800-123-4567'
        tag_names = 'design,modern'
        website = 'http://www.example.com'

        PaperTrail.track_changes_with(raw_input) do
          organization = Fabricate :organization
          Fabricate :email, content: email, organization: organization
          Fabricate(:location,
                    organization: organization,
                    city: city,
                    country: country,
                    content: location,
                    latitude: latitude,
                    longitude: longitude)
          Fabricate(:organization_name,
                    organization: organization,
                    content: organization_name)
          Fabricate(:phone_number,
                    content: phone_number,
                    organization: organization)
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
            email: email,
            city: city,
            country: country,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            phone_number: phone_number,
            tag_names: tag_names,
            website: website,
            sources: [source.name]
          }
        )
      end
    end

    context 'data with tied ranks' do
      it 'breaks ties with created_at - newest wins' do
        organization = nil

        source = Fabricate :source

        first_import = Fabricate :import, source: source
        first_raw_input = Fabricate :raw_input, import: first_import
        first_tag_name = 'modern'

        PaperTrail.track_changes_with(first_raw_input) do
          organization = Fabricate :organization
          Fabricate :email, organization: organization
          Fabricate :location, organization: organization
          Fabricate :organization_name, organization: organization
          Fabricate :phone_number, organization: organization
          tag = Fabricate :tag, name: first_tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization
        end

        city = 'Paris'
        country = 'France'
        email = 'info@example.com'
        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        phone_number = '1-800-123-4567'
        website = 'http://www.example.com'

        second_import = Fabricate :import, source: source
        second_raw_input = Fabricate :raw_input, import: second_import
        second_tag_name = 'design'

        PaperTrail.track_changes_with(second_raw_input) do
          Fabricate :email, content: email, organization: organization
          Fabricate(:location,
                    organization: organization,
                    city: city,
                    country: country,
                    content: location,
                    latitude: latitude,
                    longitude: longitude)
          Fabricate(:organization_name,
                    organization: organization,
                    content: organization_name)
          Fabricate(:phone_number,
                    content: phone_number,
                    organization: organization)
          tag = Fabricate :tag, name: second_tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization, content: website
        end

        resolved = OrganizationResolver.resolve organization

        expect(resolved).to eq(
          {
            bearden_id: organization.id,
            city: city,
            country: country,
            email: email,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            phone_number: phone_number,
            tag_names: [first_tag_name, second_tag_name].join(','),
            website: website,
            sources: [source.name]
          }
        )
      end
    end

    context 'with two sets of data' do
      it 'returns only the highest ranked data' do
        organization = nil

        city = 'Tulum'
        country = 'Mexico'
        email = 'info@example.com'
        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        phone_number = '1-800-123-4567'
        website = 'http://www.example.com'

        first_source = Fabricate(:source,
                                 email_rank: 1,
                                 location_rank: 2,
                                 organization_name_rank: 1,
                                 phone_number_rank: 2,
                                 website_rank: 1)
        first_import = Fabricate :import, source: first_source
        first_raw_input = Fabricate :raw_input, import: first_import
        first_tag_name = 'modern'

        PaperTrail.track_changes_with(first_raw_input) do
          organization = Fabricate :organization
          Fabricate :email, content: email, organization: organization
          Fabricate(:location,
                    organization: organization,
                    city: city,
                    country: country)
          Fabricate(:organization_name,
                    organization: organization,
                    content: organization_name)
          Fabricate :phone_number, organization: organization
          tag = Fabricate :tag, name: first_tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization, content: website
        end

        second_source = Fabricate(:source,
                                  email_rank: 2,
                                  location_rank: 1,
                                  organization_name_rank: 2,
                                  phone_number_rank: 1,
                                  website_rank: 2)
        second_import = Fabricate :import, source: second_source
        second_raw_input = Fabricate :raw_input, import: second_import
        second_tag_name = 'design'

        PaperTrail.track_changes_with(second_raw_input) do
          Fabricate :email, organization: organization
          Fabricate(:location,
                    organization: organization,
                    city: city,
                    country: country,
                    content: location,
                    latitude: latitude,
                    longitude: longitude)
          Fabricate :organization_name, organization: organization
          Fabricate(:phone_number,
                    content: phone_number,
                    organization: organization)
          tag = Fabricate :tag, name: second_tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization
        end

        resolved = OrganizationResolver.resolve organization

        expect(resolved).to eq(
          {
            bearden_id: organization.id,
            city: city,
            country: country,
            email: email,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            phone_number: phone_number,
            tag_names: [first_tag_name, second_tag_name].join(','),
            website: website,
            sources: Source.all.map(&:name)
          }
        )
      end
    end
  end
end
