class RawInputChanges
  def self.apply(raw_input)
    new(raw_input).apply
  end

  def initialize(raw_input)
    @raw_input = raw_input
    @attrs = raw_input.transform
  end

  # rubocop:disable Metrics/MethodLength
  # TODO: This method is one line too long!
  def apply
    organization = matching_website&.organization
    if organization.nil?
      organization = create_organization
      state = RawInput::CREATED
    else
      add_relationships(organization)
      state = RawInput::UPDATED
    end
    @raw_input.record_result state, organization
  rescue => e
    @raw_input.record_error e
  end
  # rubocop:enable Metrics/MethodLength

  private

  def url
    @attrs.fetch(:website, {})[:content]
  end

  def matching_website
    @matching_website ||= Website.find_by(content: url)
  end

  def add_relationships(organization)
    PaperTrail.track_changes_with_transaction(@raw_input) do
      organization.locations.create! @attrs[:location] if @attrs[:location]
      if @attrs[:organization_name]
        organization.organization_names.create! @attrs[:organization_name]
      end
    end
  end

  def create_organization
    organization = nil
    PaperTrail.track_changes_with_transaction(@raw_input) do
      organization = Organization.create!
      organization.websites.create! @attrs[:website] if @attrs[:website]
      add_relationships(organization)
    end
    organization
  end
end
