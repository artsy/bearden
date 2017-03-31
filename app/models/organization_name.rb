class OrganizationName < ApplicationRecord
  belongs_to :organization

  validates :content, presence: true
  validates_uniqueness_of :content, scope: :organization

  has_paper_trail ignore: %i(created_at updated_at)
  include Rankable
end
