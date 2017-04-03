class Website < ApplicationRecord
  belongs_to :organization
  validates :organization, presence: true
  validates :content, presence: true, uniqueness: true
  validates_format_of :content, with: /\./
  has_paper_trail ignore: %i(created_at updated_at)
  include Rankable
end
