class RawInputChanges
  class InvalidData < StandardError; end

  def self.apply(raw_input)
    new(raw_input).apply
  end

  def initialize(raw_input)
    @raw_input = raw_input
    @attrs = raw_input.transform
    @organization = nil
    @relations = {}
    @relations_to_build = [:email, :location, :organization_name, :phone_number]
    @error_details = {}
  end

  def apply
    PaperTrail.track_changes_with_transaction(@raw_input) do
      find_or_create_organization
      build_relations
      apply_tags
      save_relations
      check_errors
    end

    @raw_input.record_result @state, @organization
  rescue => e
    @raw_input.record_error e, @error_details
  end

  private

  def find_or_create_organization
    @state = matching_organization ? RawInput::UPDATED : RawInput::CREATED
    @organization = matching_organization || create_organization
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
    @relations_to_build << :website
    @organization = Organization.create!
  end

  def build_relations
    @relations_to_build.each do |relation|
      next unless @attrs[relation]
      method = relation.to_s.pluralize
      object = @organization.send(method).build @attrs[relation]
      @relations[relation] = object
    end
  end

  def apply_tags
    OrganizationTag.apply(@attrs[:tag_names], @organization)
  rescue OrganizationTag::TagNotFound
    @error_details[:tags] = "all tags could not be applied: #{@attrs[:tag_names].join(',')}"
  end

  def save_relations
    @relations.values.each(&:save)
  end

  def check_errors
    @relations.each do |type, object|
      error_details = object.errors.details.presence
      @error_details[type] = error_details if error_details
    end

    raise InvalidData if @error_details.any?
  end
end
