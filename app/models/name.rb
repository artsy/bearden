class Name < ApplicationRecord
  has_many :imports_organizations_name
  has_many :imports, through: :imports_organizations_names

  validates :content, presence: true
end
