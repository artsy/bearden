class Location < ApplicationRecord
  validates :address1, presence: true
  has_paper_trail ignore: [:created_at, :updated_at]
end
