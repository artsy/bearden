class AppliedTag < ApplicationRecord
  belongs_to :tag
  belongs_to :import

  validates_uniqueness_of :organization_id, scope: [:tag, :import]
end
