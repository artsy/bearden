require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'adds new tags' do
    tag = Fabricate(:tag, companies: [Fabricate(:company), Fabricate(:company)])
    expect(tag.companies.count).to eql 2
  end
end
