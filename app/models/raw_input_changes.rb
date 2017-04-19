class RawInputChanges
  class InvalidData < StandardError; end

  VALID_RELATIONS = %i[email location organization_name phone_number].freeze

  def self.apply(raw_input)
    new(raw_input).apply
  end

  def initialize(raw_input)
    @raw_input = raw_input
    @attrs = raw_input.transform
    @relations = {}
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
    url = @attrs.fetch(:website, {})[:content]
    builder = OrganizationBuilder.new url
    builder.find_or_create
    @state = builder.created? ? RawInput::CREATED : RawInput::UPDATED
    @organization = builder.organization
  end

  def relations_to_build
    VALID_RELATIONS & @attrs.keys
  end

  def build_relations
    relations_to_build.each do |relation|
      method = relation.to_s.pluralize
      object = @organization.public_send(method).build @attrs[relation]
      @relations[relation] = object
    end
  end

  def apply_tags
    OrganizationTag.apply(@attrs[:tag_names], @organization)
  rescue OrganizationTag::TagNotFound
    message = "all tags could not be applied: #{@attrs[:tag_names].join(',')}"
    @error_details[:tags] = message
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
