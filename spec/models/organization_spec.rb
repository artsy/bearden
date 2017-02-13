require 'rails_helper'

RSpec.describe Organization do
  it 'has multiple tags' do
    tags = Fabricate.times 2, :tag
    organization = Fabricate :organization, tags: tags
    expect(organization.tags.count).to eql 2
  end

  it 'has multiple locations' do
    locations = Fabricate.times 2, :location
    organization = Fabricate :organization, locations: locations
    expect(organization.locations.count).to eql 2
  end
end
