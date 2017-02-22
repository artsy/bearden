class OrganizationName < ApplicationRecord
  belongs_to :organization

  validates_presence_of :content
  validates_uniqueness_of :organization, scope: [:import, :name]

  has_paper_trail ignore: [:created_at, :updated_at]
end
