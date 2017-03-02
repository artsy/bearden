class Source < ApplicationRecord
  has_many :imports
  validates :name, presence: true
  validates_uniqueness_of :rank
end
