class CsvTransformer
  def self.allowed_headers
    %w(
      email
      location
      latitude
      longitude
      organization_name
      phone_number
      tag_names
      website
    )
  end

  def self.transform(raw_input)
    new(raw_input).transform
  end

  def initialize(raw_input)
    @data = raw_input.data
  end

  def transform
    {
      email: email_attrs,
      location: location_attrs,
      organization_name: organization_name_attrs,
      phone_number: phone_number_attrs,
      tag_names: tag_names,
      website: website_attrs
    }.delete_if { |_, v| v.empty? }
  end

  private

  def email_attrs
    {
      content: @data['email'].presence
    }.compact
  end

  def location_attrs
    {
      content: @data['location'].presence,
      latitude: @data['latitude'].presence,
      longitude: @data['longitude'].presence
    }.compact
  end

  def organization_name_attrs
    {
      content: @data['organization_name'].presence
    }.compact
  end

  def phone_number_attrs
    {
      content: @data['phone_number'].presence
    }.compact
  end

  def tag_names
    @data['tag_names']&.split(',')&.map(&:strip) || []
  end

  def website_attrs
    {
      content: @data['website'].presence
    }.compact
  end
end
