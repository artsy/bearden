class Email < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  validates_format_of :content, with: /@/
  has_paper_trail ignore: [:created_at, :updated_at]
  include Rankable
end
