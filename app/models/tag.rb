class Tag < ApplicationRecord
  has_many :imports_organizations_tags
  has_many :imports, through: :imports_organizations_tags

  validates :name, presence: true
end
