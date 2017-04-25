class Email < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  validates :content, format: /@/
  include Auditable
  include Rankable
end
