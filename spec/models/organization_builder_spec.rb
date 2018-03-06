require 'rails_helper'

describe OrganizationBuilder do
  describe 'building' do
    context 'with a matching website' do
      it 'finds the organization for that website and does not create one' do
        organization = Fabricate :organization
        website = Fabricate :website, organization: organization

        builder = OrganizationBuilder.new(website.content)
        builder.find_or_create

        expect(builder.organization).to eq organization
        expect(builder).to_not be_created

        expect(Organization.count).to eq 1
        expect(Website.count).to eq 1
      end
    end

    context 'with a new website' do
      it 'creates and organization and website' do
        website = 'http://example.com'
        results = [{ status: 200, content: website }]
        resolver = double(:resolver, results: results, resolved_url: website)
        expect(WebsiteResolver).to receive(:resolve).and_return(resolver)

        builder = OrganizationBuilder.new(website)
        builder.find_or_create

        expect(Organization.count).to eq 1
        organization = builder.organization
        expect(organization.websites.count).to eq 1
        expect(builder).to be_created
      end
    end

    context 'with an invalid website' do
      it 'raises an exception' do
        resolver = double(:resolver, results: [], resolved_url: nil)
        expect(WebsiteResolver).to receive(:resolve).and_return(resolver)

        builder = OrganizationBuilder.new('example')

        expect do
          builder.find_or_create
        end.to raise_error OrganizationBuilder::NoWebsiteBuilt
      end
    end
  end
end
