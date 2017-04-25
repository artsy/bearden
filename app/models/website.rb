class Website < ApplicationRecord
  belongs_to :organization
  validates :organization, presence: true
  validates :content, presence: true, uniqueness: true
  validates :content, format: { with: /\./ }
  include Rankable
  include Auditable
end
