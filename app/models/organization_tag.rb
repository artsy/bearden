class OrganizationTag < ApplicationRecord
  belongs_to :organization
  belongs_to :tag
  validates_uniqueness_of :tag, scope: :organization

  has_paper_trail ignore: [:created_at, :updated_at]

  def self.apply(tag_names, organization)
    Array(tag_names).each do |tag_name|
      tag = Tag.find_or_create_by name: tag_name.downcase
      next if organization.tags.exists?(name: tag.name)
      organization.organization_tags.create!(tag: tag)
    end
  end
end
