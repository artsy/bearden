require 'rails_helper'

describe OrganizationTag do
  describe 'validation' do
    it 'is not valid with duplicate organization ids' do
      organization = Fabricate :organization
      tag = Fabricate :tag

      Fabricate :organization_tag, organization: organization, tag: tag

      expect do
        Fabricate :organization_tag, organization: organization, tag: tag
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe '.apply' do
    context 'with nil tag names' do
      it 'does nothing' do
        organization = Fabricate :organization
        OrganizationTag.apply nil, organization
        expect(organization.tags.count).to eq 0
      end
    end

    context 'with a new tag' do
      it 'creates that tag and applies to the organization' do
        organization = Fabricate :organization
        OrganizationTag.apply ['new_tag'], organization
        expect(organization.tags.count).to eq 1
        expect(organization.tags.first.name).to eq 'new_tag'
      end
    end

    context 'with an existing tag and an organzation without that tag' do
      it 'applies that tag to that organzation' do
        organization = Fabricate :organization
        tag = Fabricate :tag
        OrganizationTag.apply [tag.name], organization
        expect(Tag.count).to eq 1
        expect(organization.tags.count).to eq 1
      end
    end

    context 'with an existing tag and an organzation with that tag' do
      it 'ignores that tag for that organzation' do
        organization = Fabricate :organization
        tag = Fabricate :tag
        Fabricate :organization_tag, organization: organization, tag: tag
        OrganizationTag.apply [tag.name], organization
        expect(OrganizationTag.count).to eq 1
        expect(Tag.count).to eq 1
        expect(organization.tags.count).to eq 1
      end
    end

    context 'with an existing tag with different case' do
      it 'ignores that tag for that organization' do
        organization = Fabricate :organization
        tag = Fabricate :tag, name: 'foo'
        Fabricate :organization_tag, organization: organization, tag: tag
        OrganizationTag.apply ['FOO'], organization
        expect(OrganizationTag.count).to eq 1
        expect(Tag.count).to eq 1
        expect(organization.tags.count).to eq 1
      end
    end

    context 'with a few tags' do
      it 'applies each of them' do
        organization = Fabricate :organization
        OrganizationTag.apply %w(new_tag another last_tag), organization
        expect(organization.tags.count).to eq 3
      end
    end
  end
end
