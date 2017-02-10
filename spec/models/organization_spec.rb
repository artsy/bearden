require 'rails_helper'

RSpec.describe Organization do
  it 'has multiple tags' do
    organization = Fabricate :organization, tags: [Fabricate(:tag), Fabricate(:tag)]
    expect(organization.tags.count).to eql 2
  end

  it 'has multiple locations' do
    organization = Fabricate :organization, locations: [Fabricate(:location), Fabricate(:location)]
    expect(organization.locations.count).to eql 2
  end
end
