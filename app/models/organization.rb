class Organization < ApplicationRecord
  CLOSED = 'closed'.freeze
  OPEN = 'open'.freeze
  UNKNOWN = 'unknown'.freeze

  has_many :emails
  has_many :locations
  has_many :organization_names
  has_many :organization_tags
  has_many :organization_types
  has_many :phone_numbers
  has_many :tags, through: :organization_tags
  has_many :websites

  before_validation :ensure_in_business_value
  validates :in_business, inclusion: { in: [CLOSED, OPEN, UNKNOWN] }

  include Auditable

  def contributing_sources
    sources = self.sources
    sources << auditable_relations.map do |model_name|
      send(model_name).map(&:sources)
    end
    sources.flatten.uniq
  end

  private

  def auditable_relations
    keys = self.class.reflections.keys

    relations = keys.each_with_object({}) do |key, obj|
      obj[key] = key.classify.safe_constantize
    end

    relations.map do |name, klass|
      name if klass && klass.ancestors.include?(Auditable)
    end.compact
  end

  def ensure_in_business_value
    return if in_business
    self.in_business = UNKNOWN
  end
end
