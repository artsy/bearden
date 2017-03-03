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
      website: @website&.content
    }.compact
  end
end
