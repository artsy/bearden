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
  include Estella::Searchable

  searchable do
    field :id, type: 'integer'
    field :name, using: :names, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 1.0
    field :tag, using: :tags, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :website, using: :website_urls, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :city, using: :cities, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :country, using: :countries, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :visible_to_public, type: 'boolean'
    field :search_boost, type: 'integer'
    boost :search_boost, modifier: 'log2p', factor: 5E-4, max: 0.5
  end

  def names
    organization_names.map(&:content)
  end

  def tags
    organization_tags.map { |t| t.tag.name }
  end

  def search_boost
    locations.size
  end

  def visible_to_public
    true
  end

  def website_urls
    websites.map(&:content)
  end

  def cities
    locations.map(&:city)
  end

  def countries
    locations.map(&:country)
  end

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
