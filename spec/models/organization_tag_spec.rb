require 'rails_helper'

describe OrganizationTag do
  describe 'validation' do
    it 'is not valid with duplicate organization ids' do
      organization = Fabricate :organization
      tag = Fabricate :tag

      Fabricate :organization_tag, organization: organization, tag: tag

      expect do
        Fabricate :organization_tag, organization: organization, tag: tag
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
