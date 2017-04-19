class OrganizationName < ApplicationRecord
  belongs_to :organization
  validates :content, presence: true
  include Auditable
  include Rankable
end
