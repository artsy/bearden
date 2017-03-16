class OrganizationResolver
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

  private

  def find_highest_rankables
    @location = find_highest_rankable(@organization.locations)
    @organization_name = find_highest_rankable(@organization.organization_names)
    @website = find_highest_rankable(@organization.websites)
  end

  def find_highest_rankable(rankables)
    rankables.sort_by(&:rank).first
  end

  def highest_ranked_data
    {
      bearden_id: @organization.id,
      latitude: @location&.latitude,
      location: @location&.content,
      longitude: @location&.longitude,
      organization_name: @organization_name&.content,
      tag_names: tag_names,
      website: @website&.content
    }.compact
  end

  def organization_tag_names
    @organization&.tags || []
  end

  def tag_names
    organization_tag_names.pluck(:name).join(',')
  end
end
