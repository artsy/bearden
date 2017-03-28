class ImportErrors
  def self.export(import)
    new(import).export
  end

  def initialize(import)
    @import = import
  end

  def export
    S3CsvExport.create(rows, filename, headers) if raw_inputs_with_errors.any?
  end

  private

  def raw_inputs_with_errors
    @raw_inputs_with_errors ||= @import.raw_inputs.where(state: RawInput::ERROR)
  end

  def rows
    raw_inputs_with_errors.map do |raw_input|
      data_values = raw_input.data.values
      error_details = errors_from_details(raw_input.error_details)
      [*data_values, raw_input.exception, error_details]
    end
  end

  def filename
    "errors/#{@import.id}.csv"
  end

  def headers
    raw_inputs_with_errors.first.data.keys + %w(exception error_details)
  end

  def errors_from_details(details)
    details.map do |field, detail|
      errors = detail['content'].map { |obj| obj['error'] }
      errors.map { |error| [field, error].join(' ') }.flatten
    end.flatten.join(', ')
  end
end
