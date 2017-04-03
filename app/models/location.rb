class Location < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  has_paper_trail ignore: %i(created_at updated_at)
  include Rankable

  def geocoded?
    latitude.present? && longitude.present?
  end

  def geocodable?
    content? && !geocoded?
  end
end
