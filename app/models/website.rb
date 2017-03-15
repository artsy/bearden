class Website < ApplicationRecord
  belongs_to :organization
  validates :organization, presence: true
  validates :content, presence: true, uniqueness: true
  has_paper_trail ignore: [:created_at, :updated_at]
  include Rankable
end
