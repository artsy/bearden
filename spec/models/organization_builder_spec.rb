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
        builder = OrganizationBuilder.new('http://example.com')
        builder.find_or_create

        expect(Organization.count).to eq 1
        organization = builder.organization
        expect(organization.websites.count).to eq 1
        expect(builder).to be_created
      end
    end

    context 'with an invalid website' do
      it 'raises an exception' do
        builder = OrganizationBuilder.new('example')

        expect do
          builder.find_or_create
        end.to raise_error OrganizationBuilder::NoWebsiteBuilt
      end
    end
  end
end
