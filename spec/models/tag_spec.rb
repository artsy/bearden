require 'rails_helper'

RSpec.describe Tag do
  it 'has multiple tags' do
    tag = Fabricate(:tag, organizations: [Fabricate(:organization), Fabricate(:organization)])
    expect(tag.organizations.count).to eql 2
  end

  it 'has multiple sources' do
    tag = Fabricate(:tag, sources: [Fabricate(:source), Fabricate(:source)])
    expect(tag.sources.count).to eql 2
  end
end
