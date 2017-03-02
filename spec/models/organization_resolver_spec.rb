require 'rails_helper'

describe OrganizationResolver do
  describe '.resolve' do
    context 'with no data' do
      it 'returns an array of nils' do
        organization = Fabricate :organization
        resolved = OrganizationResolver.resolve organization
        expect(resolved).to eq([organization.id, nil, nil, nil, nil, nil])
      end
    end

    context 'with one set of data' do
      it 'returns an array of that data' do
        organization = Fabricate :organization
        location = Fabricate :location, organization: organization
        organization_name = Fabricate :organization_name, organization: organization
        website = Fabricate :website, organization: organization
        resolved = OrganizationResolver.resolve organization
        expect(resolved).to eq [
          organization.id,
          location.content,
          location.latitude,
          location.longitude,
          organization_name.content,
          website.content
        ]
      end
    end

    context 'with two sets of data' do
      it 'returns only the first data' do
        organization = Fabricate :organization
        location = Fabricate :location, organization: organization
        Fabricate :location, organization: organization
        organization_name = Fabricate :organization_name, organization: organization
        Fabricate :organization_name, organization: organization, content: 'Newer Name'
        website = Fabricate :website, organization: organization
        Fabricate :website, organization: organization
        resolved = OrganizationResolver.resolve organization
        expect(resolved).to eq [
          organization.id,
          location.content,
          location.latitude,
          location.longitude,
          organization_name.content,
          website.content
        ]
      end
    end
  end
end
