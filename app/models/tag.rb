class Tag < ApplicationRecord
  has_and_belongs_to_many :companies
  validates :name, presence: true
end
