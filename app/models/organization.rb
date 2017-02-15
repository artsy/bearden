class Organization < ApplicationRecord
  has_many :locations
  has_many :imports_organizations_names
  has_many :imports_organizations_tags
  has_many :tags, through: :imports_organizations_tags

  has_paper_trail ignore: [:created_at, :updated_at]

  def imports_organizations_tags_for(tag)
    imports_organizations_tags.where(tag: tag)
  end

  def imports_organizations_names_for(name)
    imports_organizations_names.where(name: name)
  end
end
