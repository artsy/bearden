class Tag < ApplicationRecord
  has_many :applied_tags
  has_many :imports, through: :applied_tags

  validates :name, presence: true
end
