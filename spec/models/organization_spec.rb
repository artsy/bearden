require 'rails_helper'

RSpec.describe Organization, type: :model do
  it 'has unique and shared imports_organizations_tags' do
    import_a = Fabricate :import
    import_b = Fabricate :import
    import_c = Fabricate :import

    shared_tag = Fabricate(:tag)

    org1 = Fabricate :organization
    org2 = Fabricate :organization

    org1.import_organization_tags.create! tag: shared_tag, import: import_a
    org1.import_organization_tags.create! tag: shared_tag, import: import_c
    org2.import_organization_tags.create! tag: shared_tag, import: import_b

    expect(org1.import_organization_tags_for(shared_tag).count).to eql 2
    expect(org2.import_organization_tags_for(shared_tag).count).to eql 1
  end

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
