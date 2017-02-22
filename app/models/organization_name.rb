class OrganizationName < ApplicationRecord
  belongs_to :organization

  validates_presence_of :content
  validates_uniqueness_of :organization, scope: [:import, :name]
end
