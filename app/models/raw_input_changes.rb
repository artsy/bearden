class RawInputChanges
  def self.apply(raw_input)
    new(raw_input).apply
  end

  def initialize(raw_input)
    @raw_input = raw_input
    @attrs = raw_input.transform
  end

  def apply
    if matching_organization
      update_organization
    else
      create_organization
    end
  end

  private

  def url
    @attrs.fetch(:website, {})[:content]
  end

  def matching_website
    @matching_website ||= Website.find_by(content: url)
  end

  def matching_organization
    matching_website&.organization
  end

  def update_organization
    PaperTrail.track_changes_with(@raw_input) do
      matching_organization.locations.create @attrs[:location]
      matching_organization.organization_names.create @attrs[:organization_name]
    end

    @raw_input.record_result 'updated', matching_organization
  end

  def create_organization
    organization = nil

    PaperTrail.track_changes_with(@raw_input) do
      organization = Organization.create
      organization.locations.create @attrs[:location]
      organization.organization_names.create @attrs[:organization_name]
      organization.websites.create @attrs[:website]
    end

    @raw_input.record_result 'created', organization
  end
end
