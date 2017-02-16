class ImportOrganizationName < ApplicationRecord
  belongs_to :import
  belongs_to :name
  belongs_to :organization

  validates_uniqueness_of :organization, scope: [:import, :name]

  self.table_name = 'imports_organizations_names'
end
