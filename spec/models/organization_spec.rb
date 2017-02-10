require 'rails_helper'

RSpec.describe Organization, type: :model do
  before do
    PaperTrail.whodunnit = 'Test User'
  end

  it 'has multiple tags' do
    organization = Fabricate :organization, tags: [Fabricate(:tag), Fabricate(:tag)]
    expect(organization.tags.count).to eql 2
  end

  it 'has multiple locations' do
    organization = Fabricate :organization, locations: [Fabricate(:location), Fabricate(:location)]
    expect(organization.locations.count).to eql 2
  end

  context 'when records are created and updated' do
    it 'raises an error when PaperTrail.whodunnit is nil' do
      PaperTrail.whodunnit = nil
      expect { Fabricate :organization }.to raise_error ActiveRecord::StatementInvalid
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
