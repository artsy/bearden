class OrganizationName < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true, length: { maximum: 256 }
  include Auditable
  include Rankable
end
