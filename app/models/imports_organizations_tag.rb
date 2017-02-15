class ImportsOrganizationsTag < ApplicationRecord
  belongs_to :tag
  belongs_to :import
  belongs_to :organization

  validates_uniqueness_of :organization_id, scope: [:tag, :import]
end
