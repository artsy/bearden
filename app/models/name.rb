class Name < ApplicationRecord
  has_many :import_organization_names
  has_many :imports, through: :import_organization_names

  validates :content, presence: true
end
