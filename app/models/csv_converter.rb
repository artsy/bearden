class CsvConverter
  # rubocop:disable Metrics/MethodLength
  def self.headers
    %w[
      bearden_id
      city
      country
      email
      latitude
      location
      longitude
      organization_name
      phone_number
      tag_names
      website
    ]
  end
  # rubocop:enable Metrics/MethodLength

  def self.convert(input)
    new(input).convert
  end

  def initialize(input)
    @input = input
  end

  # rubocop:disable Metrics/MethodLength
  def convert
    [
      @input[:bearden_id],
      @input[:city],
      @input[:country],
      @input[:email],
      @input[:latitude],
      @input[:location],
      @input[:longitude],
      @input[:organization_name],
      @input[:phone_number],
      @input[:tag_names],
      @input[:website]
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
