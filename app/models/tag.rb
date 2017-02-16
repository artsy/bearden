class Tag < ApplicationRecord
  has_many :import_organization_tags
  has_many :imports, through: :import_organization_tags

  validates :name, presence: true
end
