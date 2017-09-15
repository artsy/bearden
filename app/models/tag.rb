class Tag < ApplicationRecord
  has_many :organization_tags, dependent: :destroy
  has_many :organizations, through: :organization_tags, dependent: :restrict_with_exception
  validates :name, presence: true
end
