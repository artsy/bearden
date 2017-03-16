require 'rails_helper'

describe RawInputChanges do
  describe '.apply' do
    context 'with a new organization' do
      context 'with some invalid data' do
        it 'rolls back all created records' do
          allow_any_instance_of(Organization).to receive(:websites).and_raise(
            ActiveRecord::RecordInvalid
          )
          source = Fabricate :source
          import = Fabricate(
            :import,
            source: source,
            transformer: CsvTransformer
          )
          data = { website: 'raise hell' }
          raw_input = Fabricate :raw_input, import: import, data: data
          RawInputChanges.apply raw_input
          expect(raw_input.exception).to eq 'ActiveRecord::RecordInvalid'
          expect(raw_input.reload.state).to eq RawInput::ERROR
          expect(Organization.count).to eq 0
        end
      end

      it 'creates that organization and records the state' do
        source = Fabricate :source
        import = Fabricate(:import,
                           source: source,
                           transformer: CsvTransformer)
        data = {
          email: 'info@example.com',
          location: '123 Main Street, New York, NY 10001',
          latitude: '47.5543105',
          longitude: '7.598538899999999',
          organization_name: 'Best Gallery',
          phone_number: '1-800-123-4567',
          tag_names: %w(design),
          website: 'http://example.com'
        }
        raw_input = Fabricate :raw_input, import: import, data: data
        RawInputChanges.apply raw_input

        expect(Organization.count).to eq 1
        organization = Organization.first
        expect(organization.versions.first.actor).to eq raw_input

        expect(Email.count).to eq 1
        email = Email.first
        expect(email.versions.first.actor).to eq raw_input

        expect(Location.count).to eq 1
        location = Location.first
        expect(location.versions.first.actor).to eq raw_input

        expect(OrganizationName.count).to eq 1
        name = OrganizationName.first
        expect(name.versions.first.actor).to eq raw_input

        expect(OrganizationTag.count).to eq 1
        tag = OrganizationTag.first
        expect(tag.versions.first.actor).to eq raw_input

        expect(PhoneNumber.count).to eq 1
        phone_number = PhoneNumber.first
        expect(phone_number.versions.first.actor).to eq raw_input

        expect(Website.count).to eq 1
        website = Location.first
        expect(website.versions.first.actor).to eq raw_input

        expect(raw_input.reload.output_id).to eq organization.id
        expect(raw_input.output_type).to eq organization.class.to_s
        expect(raw_input.state).to eq RawInput::CREATED

        expect(PaperTrail.whodunnit).to eq 'Test User'
      end
    end

    context 'with an existing organization' do
      it 'updates that organization with more data' do
        website = 'http://example.com'
        organization = Fabricate :organization
        Fabricate :website, organization: organization, content: website

        source = Fabricate :source
        import = Fabricate(:import,
                           source: source,
                           transformer: CsvTransformer)
        data = {
          email: 'info@example.com',
          location: '123 Main Street, New York, NY 10001',
          latitude: '47.5543105',
          longitude: '7.598538899999999',
          organization_name: 'Best Gallery',
          phone_number: '1-800-123-4567',
          tag_names: %w(design),
          website: website
        }
        raw_input = Fabricate :raw_input, import: import, data: data
        RawInputChanges.apply raw_input

        expect(Organization.count).to eq 1

        expect(organization.emails.count).to eq 1
        expect(organization.locations.count).to eq 1
        expect(organization.organization_names.count).to eq 1
        expect(organization.organization_tags.count).to eq 1
        expect(organization.phone_numbers.count).to eq 1
        expect(organization.websites.count).to eq 1

        expect(raw_input.reload.output_id).to eq organization.id
        expect(raw_input.output_type).to eq organization.class.to_s
        expect(raw_input.state).to eq RawInput::UPDATED
      end

      context 'with some invalid data' do
        it 'rolls back all created records' do
          allow_any_instance_of(Organization).to receive(:emails).and_raise(
            ActiveRecord::RecordInvalid
          )
          website = 'http://example.com'
          organization = Fabricate :organization
          Fabricate :website, organization: organization, content: website

          source = Fabricate :source
          import = Fabricate(
            :import,
            source: source,
            transformer: CsvTransformer
          )
          data = {
            website: website,
            email: 'raise hell'
          }
          raw_input = Fabricate :raw_input, import: import, data: data
          RawInputChanges.apply raw_input
          expect(raw_input.exception).to eq 'ActiveRecord::RecordInvalid'
          expect(raw_input.reload.state).to eq RawInput::ERROR
          expect(Location.count).to eq 0
        end
      end
    end
  end
end
