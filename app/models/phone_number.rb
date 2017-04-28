class PhoneNumber < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true, length: { maximum: 256 }
  include Rankable
  include Auditable
end
