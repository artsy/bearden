class Email < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  validates_format_of :content, with: /@/
  include Auditable
  include Rankable
end
