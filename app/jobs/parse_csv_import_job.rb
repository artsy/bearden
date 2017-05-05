require 'csv'
require 'charlock_holmes/string'

class ParseCsvImportJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    @import_id = import_id
    @import = Import.find_by id: @import_id
    @data = fetch_data
    create_raw_inputs
    @import.transform
  end

  private

  def fetch_data
    response = Faraday.get @import.file_identifier.url
    raw_data = response.body

    CharlockHolmes::Converter.convert(
      raw_data,
      raw_data.detect_encoding[:encoding],
      Encoding::UTF_8.to_s
    )
  end

  def create_raw_inputs
    CSV.parse(@data, headers: true) do |row|
      RawInput.create data: row.to_h, import_id: @import_id
    end
  end
end
