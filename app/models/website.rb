class Website < ApplicationRecord
  belongs_to :organization
  validates :organization, presence: true
  validates :content, presence: true, uniqueness: true
  validates_format_of :content, with: /\./
  include Rankable
  include Auditable
end
