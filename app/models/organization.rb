class Organization < ApplicationRecord
  has_many :locations

  has_many :applied_tags
  has_many :tags, through: :applied_tags

  has_paper_trail ignore: [:created_at, :updated_at]

  validates :name, presence: true

  def applied_tags_for(tag)
    applied_tags.where(tag: tag)
  end
end
