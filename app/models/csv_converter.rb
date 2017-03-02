class CsvConverter
  def self.headers
    %w(bearden_id latitude location longitude organization_name website)
  end

  def self.convert(input)
    new(input).convert
  end

  def initialize(input)
    @input = input
  end

  def convert
    [
      @input[:id],
      @input[:latitude],
      @input[:location],
      @input[:longitude],
      @input[:organization_name],
      @input[:website]
    ]
  end
end
