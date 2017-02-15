require 'rails_helper'

RSpec.describe AppliedTag, type: :model do
  it 'does not allow multiple organization IDs for the same tag-import combo' do
    org = Fabricate :organization
    tag = Fabricate :tag
    import = Fabricate :import
    create_duplicates = lambda do
      Array.new(2) do
        org.applied_tags.create! tag: tag, import: import
      end
    end
    expect(create_duplicates).to raise_error ActiveRecord::RecordInvalid
  end
end
