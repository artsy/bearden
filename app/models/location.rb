class Location < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  include Rankable
  include Auditable

  def geocoded?
    latitude.present? && longitude.present?
  end

  def geocodable?
    content? && !geocoded?
  end
end
