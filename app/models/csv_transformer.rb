class CsvTransformer
  def self.transform(raw_input)
    new(raw_input).transform
  end

  def initialize(raw_input)
    @data = raw_input.data
  end

  def transform
    {
      organization: organization_attrs,
      location: location_attrs
    }
  end

  private

  def organization_attrs
    {
      website: @data['host']
    }
  end

  def location_attrs
    {
      address1: @data['address'],
      locality: @data['city'],
      region: @data['state'],
      postcode: @data['postal_code'],
      country: @data['country'],
      lat: @data['latitude'],
      lng: @data['longitude']
    }
  end
end
