class Tag < ApplicationRecord
  has_and_belongs_to_many :organizations
  has_many :sources
  validates :name, presence: true
end
