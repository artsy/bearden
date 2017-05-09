class Tag < ApplicationRecord
  has_many :organization_tags, dependent: :destroy
  has_many :organizations, through: :organization_tags
  validates :name, presence: true
end
