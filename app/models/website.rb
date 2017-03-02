class Website < ApplicationRecord
  belongs_to :organization
  validates_presence_of :content
  has_paper_trail ignore: [:created_at, :updated_at]
  include Rankable
end
