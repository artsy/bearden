class OrganizationTag < ApplicationRecord
  belongs_to :organization
  belongs_to :tag
  validates_uniqueness_of :tag, scope: :organization
end
