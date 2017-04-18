class OrganizationBuilder
  class NoWebsiteBuilt < StandardError; end

  attr_reader :organization

  def initialize(input_website)
    @input_website = input_website
    @created = false
  end

  def find_or_create
    return if organization_from(@input_website)

    resolve_website
    organization_from(resolved_url)

    create_organization unless @organization

    @resolver.results.each do |attrs|
      @organization.websites.create attrs
    end

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

  def resolved_url
    @resolver.resolved_url
  end

  def resolve_website
    @resolver = WebsiteResolver.resolve(@input_website)
  end

  def create_organization
    @organization = Organization.create
    @created = true
  end

  def website_built?
    @organization.reload.websites.any?
  end
end
