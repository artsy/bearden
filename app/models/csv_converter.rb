class CsvConverter
  def self.headers
    %w(
      bearden_id
      latitude
      location
      longitude
      organization_name
      tag_names
      website
    )
  end

  def self.convert(input)
    new(input).convert
  end

  def initialize(input)
    @input = input
  end

  def convert
    [
      @input[:bearden_id],
      @input[:latitude],
      @input[:location],
      @input[:longitude],
      @input[:organization_name],
      @input[:tag_names],
      @input[:website]
    ]
  end
end
