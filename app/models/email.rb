class Email < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true, format: /@/, length: { maximum: 256 }
  include Auditable
  include Rankable
end
