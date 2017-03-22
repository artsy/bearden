require 'rails_helper'

describe Organization do
  it 'has multiple locations' do
    organization = Fabricate :organization
    Fabricate.times 2, :location, organization: organization
    expect(organization.locations.count).to eql 2
  end

  context 'when records are created and updated' do
    it 'raises an error when PaperTrail.whodunnit is nil' do
      PaperTrail.whodunnit = nil
      expect { Fabricate :organization }.to raise_error(
        ActiveRecord::StatementInvalid
      )
    end
  end
end
