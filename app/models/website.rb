class Website < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  has_paper_trail ignore: [:created_at, :updated_at]
  include Rankable
end
