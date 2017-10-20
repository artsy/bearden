class OrganizationResolver
  STRING_LIMIT = 256

  def self.resolve(organization)
    new(organization).resolve
  end

  def initialize(organization)
    @organization = organization
  end

  def resolve
    find_highest_rankables
    highest_ranked_data
  end

  def self.rank(rankables)
    rankables.sort_by { |rankable| [rankable.rank, -rankable.created_at.to_i] }
  end

  def self.find_highest_rankable(rankables)
    rank(rankables).first
  end

  private

  def find_highest_rankables
    @email = OrganizationResolver.find_highest_rankable(@organization.emails)
    @location = OrganizationResolver.find_highest_rankable(@organization.locations)
    @organization_name = OrganizationResolver.find_highest_rankable(@organization.organization_names)
    @organization_type = OrganizationResolver.find_highest_rankable(@organization.organization_types)
    @phone_number = OrganizationResolver.find_highest_rankable(@organization.phone_numbers)
    @website = OrganizationResolver.find_highest_rankable(@organization.websites)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def highest_ranked_data
    {
      bearden_id: @organization.id,
      city: @location&.city,
      country: @location&.country,
      email: @email&.content,
      in_business: @organization.in_business,
      latitude: @location&.latitude,
      location: @location&.content,
      longitude: @location&.longitude,
      organization_name: @organization_name&.content,
      organization_type: @organization_type&.name,
      phone_number: @phone_number&.content,
      tag_names: truncated(tag_names),
      website: @website&.content,
      sources: truncated(source_names)
    }.compact
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def organization_tag_names
    @organization&.tags || []
  end

  def source_names
    @organization.contributing_sources.map(&:name)
  end

  def tag_names
    organization_tag_names.pluck(:name).join(',')
  end

  def truncated(string)
    string[0...STRING_LIMIT]
  end
end
