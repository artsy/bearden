class Type < ApplicationRecord
  has_many :organization_types, dependent: :restrict_with_exception
  has_many :organizations, through: :organization_types, dependent: :restrict_with_exception
  validates :name, presence: true
end
