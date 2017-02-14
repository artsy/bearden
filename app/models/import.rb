class Import < ApplicationRecord
  validates :name, presence: true
  belongs_to :source
end
