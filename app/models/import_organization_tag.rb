class ImportOrganizationTag < ApplicationRecord
  belongs_to :import
  belongs_to :organization
  belongs_to :tag

  validates_uniqueness_of :organization_id, scope: [:import, :tag]

  self.table_name = 'imports_organizations_tags'
end
