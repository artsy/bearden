require 'rails_helper'

describe RawInputChanges do
  describe '.apply' do
    context 'with a new organization' do
      context 'with valid data' do
        it 'creates that organization and records the state' do
          Fabricate :tag, name: 'design'
          Fabricate :type, name: 'gallery'
          source = Fabricate :source
          import = Fabricate(:import,
                             source: source,
                             transformer: CsvTransformer)
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'info@example.com',
            location: '123 Main Street, New York, NY 10001',
            latitude: '47.5543105',
            longitude: '7.598538899999999',
            organization_name: 'Best Gallery',
            organization_type: 'gallery',
            phone_number: '1-800-123-4567',
            tag_names: 'design',
            website: 'http://example.com'
          }
          raw_input = Fabricate :raw_input, import: import, data: data

          website = 'http://example.com'
          results = [{ status: 200, content: website }]
          resolver = double(:resolver, results: results, resolved_url: website)
          expect(WebsiteResolver).to receive(:resolve).and_return(resolver)

          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            Organization,
            OrganizationName,
            OrganizationTag,
            OrganizationType,
            PhoneNumber,
            Website
          ].each do |klass|
            expect(klass.count).to eq 1
            first = klass.first
            expect(first.versions.first.actor).to eq raw_input
          end

          organization = Organization.first
          expect(raw_input.reload.output_id).to eq organization.id
          expect(raw_input.output_type).to eq organization.class.to_s
          expect(raw_input.state).to eq RawInput::CREATED

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end

      context 'with a nil website' do
        it 'rolls back all records, saves exception and notes the result' do
          Fabricate :tag, name: 'design'
          Fabricate :type, name: 'gallery'
          source = Fabricate :source
          import = Fabricate(:import,
                             source: source,
                             transformer: CsvTransformer)
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'info@example.com',
            location: '123 Main Street, New York, NY 10001',
            latitude: '47.5543105',
            longitude: '7.598538899999999',
            organization_name: 'Best Gallery',
            organization_type: 'gallery',
            phone_number: '1-800-123-4567',
            tag_names: 'design',
            website: nil
          }
          raw_input = Fabricate :raw_input, import: import, data: data
          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            Organization,
            OrganizationName,
            OrganizationTag,
            PhoneNumber,
            Website
          ].each do |klass|
            expect(klass.count).to eq 0
          end
          exception = 'OrganizationBuilder::NoWebsiteBuilt'
          expect(raw_input.exception).to eq exception
          expect(raw_input.state).to eq RawInput::ERROR

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end

      context 'with some invalid data' do
        it 'rolls back all records, saves errors and notes the result' do
          Fabricate :tag, name: 'design'
          Fabricate :type, name: 'gallery'
          source = Fabricate :source
          import = Fabricate(:import,
                             source: source,
                             transformer: CsvTransformer)
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'infoexample.com',
            location: '123 Main Street, New York, NY 10001',
            latitude: '47.5543105',
            longitude: '7.598538899999999',
            organization_name: 'Best Gallery',
            organization_type: 'invalid',
            phone_number: '1-800-123-4567',
            tag_names: 'invalid',
            website: 'http://example.com'
          }
          raw_input = Fabricate :raw_input, import: import, data: data
          website = 'http://example.com'
          results = [{ status: 200, content: website }]
          resolver = double(:resolver, results: results, resolved_url: website)
          expect(WebsiteResolver).to receive(:resolve).and_return(resolver)
          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            Organization,
            OrganizationName,
            OrganizationTag,
            OrganizationType,
            PhoneNumber,
            Website
          ].each do |klass|
            expect(klass.count).to eq 0
          end
          expect(raw_input.exception).to eq 'RawInputChanges::InvalidData'
          expect(raw_input.error_details).to eq(
            {
              'email' => { 'content' => [{ 'error' => 'invalid', 'value' => 'infoexample.com' }] },
              'organization_type' => { 'type' => [{ 'error' => 'blank' }] },
              'tags' => 'all tags could not be applied: invalid'
            }
          )
          expect(raw_input.state).to eq RawInput::ERROR

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end

      context 'with all invalid data' do
        it 'rolls back all records, saves errors and notes the result' do
          source = Fabricate :source
          import = Fabricate(
            :import,
            source: source,
            transformer: CsvTransformer
          )
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'infoexample.com',
            latitude: '47.5543105',
            organization_name: 'Best Gallery',
            phone_number: '1-800-123-4567',
            tag_names: 'invalid',
            website: 'example.com'
          }
          raw_input = Fabricate :raw_input, import: import, data: data

          website = 'http://example.com'
          results = [{ status: 200, content: website }]
          resolver = double(:resolver, results: results, resolved_url: website)
          expect(WebsiteResolver).to receive(:resolve).and_return(resolver)
          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            Organization,
            OrganizationName,
            OrganizationTag,
            PhoneNumber,
            Website
          ].each do |klass|
            expect(klass.count).to eq 0
          end
          expect(raw_input.exception).to eq 'RawInputChanges::InvalidData'
          expect(raw_input.error_details).to eq(
            {
              'email' => { 'content' => [{ 'error' => 'invalid', 'value' => 'infoexample.com' }] },
              'location' => { 'content' => [{ 'error' => 'blank' }] },
              'tags' => 'all tags could not be applied: invalid'
            }
          )
          expect(raw_input.state).to eq RawInput::ERROR

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end
    end

    context 'with an existing organization' do
      context 'with valid data' do
        it 'updates that organization and records the state' do
          Fabricate :tag, name: 'design'

          website = 'http://example.com'
          organization = Fabricate :organization
          Fabricate :website, organization: organization, content: website

          source = Fabricate :source
          import = Fabricate(:import,
                             source: source,
                             transformer: CsvTransformer)
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'info@example.com',
            location: '123 Main Street, New York, NY 10001',
            latitude: '47.5543105',
            longitude: '7.598538899999999',
            organization_name: 'Best Gallery',
            phone_number: '1-800-123-4567',
            tag_names: 'design',
            website: website
          }
          raw_input = Fabricate :raw_input, import: import, data: data
          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            OrganizationName,
            OrganizationTag,
            PhoneNumber
          ].each do |klass|
            expect(klass.count).to eq 1
            first = klass.first
            expect(first.versions.first.actor).to eq raw_input
          end

          organization = Organization.first
          expect(raw_input.reload.output_id).to eq organization.id
          expect(raw_input.output_type).to eq organization.class.to_s
          expect(raw_input.state).to eq RawInput::UPDATED

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end

      context 'with some invalid data' do
        it 'rolls back all records, saves errors and notes the result' do
          Fabricate :tag, name: 'design'

          website = 'http://example.com'
          organization = Fabricate :organization
          Fabricate :website, organization: organization, content: website

          source = Fabricate :source
          import = Fabricate(:import,
                             source: source,
                             transformer: CsvTransformer)
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'infoexample.com',
            location: '123 Main Street, New York, NY 10001',
            latitude: '47.5543105',
            longitude: '7.598538899999999',
            organization_name: 'Best Gallery',
            phone_number: '1-800-123-4567',
            tag_names: 'invalid',
            website: website
          }
          raw_input = Fabricate :raw_input, import: import, data: data
          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            OrganizationName,
            OrganizationTag,
            PhoneNumber
          ].each do |klass|
            expect(klass.count).to eq 0
          end
          expect(raw_input.exception).to eq 'RawInputChanges::InvalidData'
          expect(raw_input.error_details).to eq(
            {
              'email' => { 'content' => [{ 'error' => 'invalid', 'value' => 'infoexample.com' }] },
              'tags' => 'all tags could not be applied: invalid'
            }
          )
          expect(raw_input.state).to eq RawInput::ERROR

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end

      context 'with all invalid data' do
        it 'rolls back all records, saves errors and notes the result' do
          Fabricate :tag, name: 'design'

          website = 'http://example.com'
          organization = Fabricate :organization
          Fabricate :website, organization: organization, content: website

          import = Fabricate(
            :import,
            transformer: CsvTransformer
          )
          data = {
            city: 'Mexico City',
            country: 'Mexico',
            email: 'infoexample.com',
            latitude: '47.5543105',
            organization_name: 'Best Gallery',
            phone_number: '1-800-123-4567',
            tag_names: 'invalid',
            website: website
          }
          raw_input = Fabricate :raw_input, import: import, data: data

          RawInputChanges.apply raw_input

          [
            Email,
            Location,
            OrganizationName,
            OrganizationTag,
            PhoneNumber
          ].each do |klass|
            expect(klass.count).to eq 0
          end
          expect(raw_input.exception).to eq 'RawInputChanges::InvalidData'
          expect(raw_input.error_details).to eq(
            {
              'email' => { 'content' => [{ 'error' => 'invalid', 'value' => 'infoexample.com' }] },
              'location' => { 'content' => [{ 'error' => 'blank' }] },
              'tags' => 'all tags could not be applied: invalid'
            }
          )
          expect(raw_input.state).to eq RawInput::ERROR

          expect(PaperTrail.whodunnit).to eq 'Test User'
        end
      end
    end

    context 'with an import that closes a business' do
      it 'marks that organization as closed' do
        organization = Fabricate :organization
        website = Fabricate :website, organization: organization
        source = Fabricate :source
        import = Fabricate :import, source: source, transformer: CsvTransformer
        data = {
          in_business: Organization::CLOSED,
          website: website.content
        }
        raw_input = Fabricate :raw_input, import: import, data: data
        RawInputChanges.apply raw_input
        expect(organization.reload.in_business).to eq Organization::CLOSED
      end
    end
  end
end
