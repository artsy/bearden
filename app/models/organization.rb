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
  include Searchable

  searchable do
    field :id, type: 'integer'
    field :name, using: :names, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 1.0
    field :tag, using: :tag_names, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :website, using: :website_urls, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :city, using: :cities, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :country, using: :countries, type: 'string', analysis: FULLTEXT_ANALYSIS, factor: 0.5
    field :visible_to_public, type: 'boolean', using: -> { true }
    field :search_boost, type: 'integer'
    boost :search_boost, modifier: 'log2p', factor: 5E-4, max: 0.5
  end

  def self.estella_search_query
    Search::OrganizationsQuery
  end

  def names
    organization_names.pluck(:content)
  end

  def tag_names
    organization_tags.map { |t| t.tag.name }
  end

  def website_urls
    websites.pluck(:content)
  end

  def cities
    locations.pluck(:city)
  end

  def countries
    locations.pluck(:country)
  end

  def search_boost
    locations.size
  end

  def contributing_sources
    sources = self.sources
    sources << auditable_relations.map do |model_name|
      send(model_name).map(&:sources)
    end
    sources.flatten.uniq
  end

  # rubocop:disable Metrics/MethodLength
  def as_json(_)
    {
      names: names,
      tags: tag_names,
      websites: website_urls,
      cities: cities,
      countries: countries,
      id: id,
      created_at: created_at,
      updated_at: updated_at,
      in_business: in_business
    }
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
