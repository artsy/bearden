class OrganizationResolver
  def self.headers
    %w(bearden_id location latitude longitude organization_name website)
  end

  def self.resolve(organization)
    new(organization).resolve
  end

  def initialize(organization)
    @organization = organization
  end

  def resolve
    [
      id,
      location,
      latitude,
      longitude,
      organization_name,
      website
    ]
  end

  private

  def id
    @organization.id
  end

  def location
    @organization.locations.first.content
  end

  def latitude
    @organization.locations.first.latitude
  end

  def longitude
    @organization.locations.first.longitude
  end

  def organization_name
    @organization.organization_names.first.content
  end

  def website
    @organization.websites.first.content
  end
end
