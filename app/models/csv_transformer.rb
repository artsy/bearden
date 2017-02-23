class CsvTransformer
  def self.transform(raw_input)
    new(raw_input).transform
  end

  def initialize(raw_input)
    @data = raw_input.data
  end

  def transform
    {
      location: location_attrs,
      organization_name: organization_name_attrs,
      website: website_attrs
    }
  end

  private

  def location_attrs
    {
      content: @data['location'],
      latitude: @data['latitude'],
      longitude: @data['longitude']
    }
  end

  def organization_name_attrs
    {
      content: @data['organization_name']
    }
  end

  def website_attrs
    {
      content: @data['website']
    }
  end
end
