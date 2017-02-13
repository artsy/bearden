class Organization < ApplicationRecord
  has_many :locations
  has_and_belongs_to_many :tags
  has_paper_trail ignore: [:created_at, :updated_at]
  validates :name, presence: true
end
