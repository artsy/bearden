class RawInputChanges
  def self.apply(raw_input)
    new(raw_input).apply
  end

  def initialize(raw_input)
    @raw_input = raw_input
    @attrs = raw_input.transform
  end

  def apply
    organization = nil

    PaperTrail.track_changes_with_transaction(@raw_input) do
      organization = find_or_create_organization
      add_relationships(organization)
    end

    @raw_input.record_result @state, organization
  rescue => e
    @raw_input.record_error e
  end

  private

  def find_or_create_organization
    @state = matching_organization ? RawInput::UPDATED : RawInput::CREATED
    matching_organization || create_organization
  end

  def matching_organization
    matching_website&.organization
  end

  def matching_website
    @matching_website ||= Website.find_by(content: url)
  end

  def url
    @attrs.fetch(:website, {})[:content]
  end

  def create_organization
    organization = Organization.create!
    organization.websites.create! @attrs[:website] if @attrs[:website]
    organization
  end

  # rubocop:disable Metrics/LineLength
  def add_relationships(organization)
    organization.locations.create! @attrs[:location] if @attrs[:location]
    organization.organization_names.create! @attrs[:organization_name] if @attrs[:organization_name]
  end
  # rubocop:enable Metrics/LineLength
end
