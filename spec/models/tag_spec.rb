require 'rails_helper'

RSpec.describe Tag do
  it 'has multiple tags' do
    organizations = Fabricate.times 2, :organization
    tag = Fabricate :tag, organizations: organizations
    expect(tag.organizations.count).to eql 2
  end

  it 'has multiple sources' do
    sources = Fabricate.times 2, :source
    tag = Fabricate :tag, sources: sources
    expect(tag.sources.count).to eql 2
  end
end
