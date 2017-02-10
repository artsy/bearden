class Organization < ApplicationRecord
  has_many :locations
  has_and_belongs_to_many :tags
  validates :name, presence: true
end
