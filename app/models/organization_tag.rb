class OrganizationTag < ApplicationRecord
  class TagNotFound < StandardError; end

  belongs_to :organization
  belongs_to :tag
  validates :tag, uniqueness: { scope: :organization }

  include Auditable

  def self.apply(tag_names, organization)
    Array(tag_names).each do |tag_name|
      tag = Tag.find_by name: tag_name.downcase
      raise TagNotFound unless tag
      next if organization.tags.exists?(name: tag.name)
      organization.organization_tags.create!(tag: tag)
    end
  end
end
