class ImportOrganizationTag < ApplicationRecord
  belongs_to :tag
  belongs_to :import
  belongs_to :organization

  validates_uniqueness_of :organization_id, scope: [:tag, :import]

  self.table_name = 'imports_organizations_tags'
end
