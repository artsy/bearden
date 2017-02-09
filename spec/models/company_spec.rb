require 'rails_helper'

RSpec.describe Company, type: :model do
  it 'adds new tags' do
    company = Fabricate :company, tags: [Fabricate(:tag), Fabricate(:tag)]
    expect(company.tags.count).to eql 2
  end

  it 'adds new addresses' do
    company = Fabricate :company, addresses: [Fabricate(:address), Fabricate(:address)]
    expect(company.addresses.count).to eql 2
  end
end
