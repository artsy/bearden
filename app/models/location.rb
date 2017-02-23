class Location < ApplicationRecord
  validates :content, presence: true
  has_paper_trail ignore: [:created_at, :updated_at]
end
