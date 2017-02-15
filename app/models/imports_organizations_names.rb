class ImportsOrganizationsName < ActiveRecord
  belongs_to :name
  belongs_to :import
  belongs_to :organization

  validates_uniqueness_of :organization, scope: [:name, :import]
end
