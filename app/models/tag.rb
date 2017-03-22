class Tag < ApplicationRecord
  has_many :organization_tags
  has_many :organizations, through: :organization_tags
  validates :name, presence: true
end
