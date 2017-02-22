class OrganizationName < ApplicationRecord
  belongs_to :organization

  validates_presence_of :content
  validates_uniqueness_of :content, scope: :organization

  has_paper_trail ignore: [:created_at, :updated_at]
end
