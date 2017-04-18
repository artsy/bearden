class PhoneNumber < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  include Rankable
  include Auditable
end
