class Location < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  has_paper_trail ignore: [:created_at, :updated_at]
  include Rankable

  def geocoded?
    latitude.present? && longitude.present?
  end

  def geocodable?
    content? && !geocoded?
  end

  def self.geocoder_source
    return if Source.find_by name: 'Geocoder'
    Source.create name: 'Geocoder', rank: 100_000
  end
end
