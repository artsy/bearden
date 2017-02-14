require 'rails_helper'

RSpec.describe Organization, type: :model do
  it 'has unique and shared tag_sources' do
    import_a = Fabricate :import
    import_b = Fabricate :import
    import_c = Fabricate :import

    shared_tag = Fabricate(:tag, name: 'Museum')

    org1 = Fabricate :organization
    org2 = Fabricate :organization

    org1.applied_tags.create! tag: shared_tag, import: import_a
    org1.applied_tags.create! tag: shared_tag, import: import_c
    org2.applied_tags.create! tag: shared_tag, import: import_b

    expect(org1.applied_tags_for(shared_tag).count).to eql 2
    expect(org2.applied_tags_for(shared_tag).count).to eql 1
  end

  it 'has multiple locations' do
    locations = Fabricate.times 2, :location
    organization = Fabricate :organization, locations: locations
    expect(organization.locations.count).to eql 2
  end

  context 'when records are created and updated' do
    it 'raises an error when PaperTrail.whodunnit is nil' do
      PaperTrail.whodunnit = nil
      expect { Fabricate :organization }.to raise_error(
        ActiveRecord::StatementInvalid
      )
    end

    it 'PaperTrail creates the first version' do
      organization = Fabricate :organization
      expect(organization.versions.count).to eql 1
    end

    it 'PaperTrail ascribes the correct user to the `whodunnit` field' do
      PaperTrail.whodunnit = 'Artsy Admin'
      organization = Fabricate :organization
      expect(organization.versions.first.whodunnit).to eql 'Artsy Admin'
      PaperTrail.whodunnit = 'Apollo'
      organization.update_attribute :name, 'Delphi'
      expect(organization.versions.second.whodunnit).to eql 'Apollo'
    end

    it 'PaperTrail can revert an organization' do
      organization = Fabricate :organization, website: 'https://example.com'
      organization.update_attribute :website, 'https://artsy.net'
      organization = organization.paper_trail.previous_version
      organization.save
      expect(organization.website).to eql 'https://example.com'
    end
  end
end
