require 'rails_helper'

describe OrganizationResolver do
  describe '.rank' do
    let(:organization) { Fabricate(:organization) }
    let!(:raw_input_1) { Fabricate(:raw_input, import: Fabricate(:import, source: Fabricate(:source))) }
    let!(:raw_input_2) { Fabricate(:raw_input, import: Fabricate(:import, source: Fabricate(:source))) }

    it 'sorts by lowest rank then newest record' do
      # ranks sequentially in the fabricator
      rank1 = raw_input_1.source.rank_for(:organization_name_rank)
      rank2 = raw_input_2.source.rank_for(:organization_name_rank)
      expect(rank2).to eq rank1 + 1

      PaperTrail.track_changes_with(raw_input_1) do
        @n1 = Fabricate(:organization_name, organization: organization, created_at: Time.at(1))
      end

      PaperTrail.track_changes_with(raw_input_2) do
        @n2 = Fabricate(:organization_name, organization: organization, created_at: Time.at(1))
        @n3 = Fabricate(:organization_name, organization: organization, created_at: Time.at(2))
      end

      expect(OrganizationResolver.rank(organization.organization_names)).to eq [@n1, @n3, @n2]
    end
  end

  describe '.resolve' do
    context 'with no related data' do
      it 'returns only organization details' do
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
            in_business: organization.in_business,
            sources: [source.name],
            tag_names: ''
          }
        )
      end
    end

    context 'with one set of data' do
      it 'returns all resolved data' do
        type = Fabricate :type, name: 'gallery'
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
        organization_type = 'gallery'
        phone_number = '1-800-123-4567'
        tag_names = 'design,modern'
        website = 'http://www.example.com'

        PaperTrail.track_changes_with(raw_input) do
          organization = Fabricate :organization
          Fabricate :email, content: email, organization: organization
          Fabricate(:location, organization: organization, city: city, country: country, content: location, latitude: latitude, longitude: longitude)
          Fabricate(:organization_name, organization: organization, content: organization_name)
          Fabricate(:organization_type, organization: organization, type: type)
          Fabricate(:phone_number, content: phone_number, organization: organization)
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
            city: city,
            country: country,
            email: email,
            in_business: organization.in_business,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            organization_type: organization_type,
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

        type = Fabricate :type, name: 'gallery'
        source = Fabricate :source

        first_import = Fabricate :import, source: source
        first_raw_input = Fabricate :raw_input, import: first_import
        first_tag_name = 'modern'

        PaperTrail.track_changes_with(first_raw_input) do
          organization = Fabricate :organization
          Fabricate :email, organization: organization, created_at: Time.at(1)
          Fabricate :location, organization: organization, created_at: Time.at(1)
          Fabricate :organization_name, organization: organization, created_at: Time.at(1)
          Fabricate :phone_number, organization: organization, created_at: Time.at(1)
          tag = Fabricate :tag, name: first_tag_name, created_at: Time.at(1)
          Fabricate :organization_tag, organization: organization, tag: tag, created_at: Time.at(1)
          Fabricate :website, organization: organization, created_at: Time.at(1)
        end

        city = 'Paris'
        country = 'France'
        email = 'info@example.com'
        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        organization_type = 'gallery'
        phone_number = '1-800-123-4567'
        website = 'http://www.example.com'

        second_import = Fabricate :import, source: source
        second_raw_input = Fabricate :raw_input, import: second_import
        second_tag_name = 'design'

        PaperTrail.track_changes_with(second_raw_input) do
          Fabricate :email, content: email, organization: organization, created_at: Time.at(2)
          Fabricate(:location, organization: organization, city: city, country: country, content: location, latitude: latitude, longitude: longitude, created_at: Time.at(2))
          Fabricate(:organization_name, organization: organization, content: organization_name, created_at: Time.at(2))
          Fabricate(:organization_type, organization: organization, type: type, created_at: Time.at(2))
          Fabricate(:phone_number, content: phone_number, organization: organization, created_at: Time.at(2))
          tag = Fabricate :tag, name: second_tag_name, created_at: Time.at(2)
          Fabricate :organization_tag, organization: organization, tag: tag, created_at: Time.at(2)
          Fabricate :website, organization: organization, content: website, created_at: Time.at(2)
        end

        resolved = OrganizationResolver.resolve organization

        expect(resolved).to eq(
          {
            bearden_id: organization.id,
            city: city,
            country: country,
            email: email,
            in_business: organization.in_business,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            organization_type: organization_type,
            phone_number: phone_number,
            tag_names: [first_tag_name, second_tag_name].join(','),
            website: website,
            sources: [source.name]
          }
        )
      end
    end

    context 'with two sets of data' do
      it 'returns only the highest ranked data (lowest rank first, then newest first)' do
        type = Fabricate :type, name: 'gallery'
        organization = nil

        city = 'Tulum'
        country = 'Mexico'
        email = 'info@example.com'
        latitude = 90.0
        location = '123 main street'
        longitude = 70.0
        organization_name = 'The Best Gallery'
        organization_type = 'gallery'
        phone_number = '1-800-123-4567'
        website = 'http://www.example.com'

        first_source = Fabricate(:source, email_rank: 1, location_rank: 2, organization_name_rank: 1, organization_type_rank: 2, phone_number_rank: 2, website_rank: 1)
        first_import = Fabricate :import, source: first_source
        first_raw_input = Fabricate :raw_input, import: first_import
        first_tag_name = 'modern'

        PaperTrail.track_changes_with(first_raw_input) do
          organization = Fabricate :organization
          Fabricate :email, content: email, organization: organization
          Fabricate(:location, organization: organization, city: city, country: country)
          Fabricate(:organization_name, organization: organization, content: organization_name)
          Fabricate(:organization_type, organization: organization, type: Fabricate(:type))
          Fabricate :phone_number, organization: organization
          tag = Fabricate :tag, name: first_tag_name
          Fabricate :organization_tag, organization: organization, tag: tag
          Fabricate :website, organization: organization, content: website
        end

        second_source = Fabricate(:source, email_rank: 2, location_rank: 1, organization_name_rank: 2, organization_type_rank: 1, phone_number_rank: 1, website_rank: 2)
        second_import = Fabricate :import, source: second_source
        second_raw_input = Fabricate :raw_input, import: second_import
        second_tag_name = 'design'

        PaperTrail.track_changes_with(second_raw_input) do
          Fabricate :email, organization: organization
          Fabricate(:location, organization: organization, city: city, country: country, content: location, latitude: latitude, longitude: longitude)
          Fabricate :organization_name, organization: organization
          Fabricate(:organization_type, organization: organization, type: type)
          Fabricate(:phone_number, content: phone_number, organization: organization)
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
            in_business: organization.in_business,
            latitude: latitude,
            location: location,
            longitude: longitude,
            organization_name: organization_name,
            organization_type: organization_type,
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
