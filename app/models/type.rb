class Type < ApplicationRecord
  has_many :organization_types
  has_many :organizations, through: :organization_types
  validates :name, presence: true
end
