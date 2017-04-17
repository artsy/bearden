class OrganizationBuilder
  class NoWebsiteBuilt < StandardError; end

  attr_reader :organization

  def initialize(input_website)
    @input_website = input_website
    @created = false
  end

  def find_or_create
    return if organization_from(@input_website)

    create_organization
    raise NoWebsiteBuilt unless website_built?
  end

  def created?
    @created
  end

  private

  def organization_from(content)
    website = Website.find_by content: content
    @organization = website&.organization
  end

  def create_organization
    @organization = Organization.create
    @organization.websites.create content: @input_website

    @created = true
  end

  def website_built?
    @organization.reload.websites.any?
  end
end
