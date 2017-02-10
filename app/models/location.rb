class Location < ApplicationRecord
  validates :address1, presence: true
end
