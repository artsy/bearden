class ImportResult
  attr_reader :import

  delegate(
    :created_at,
    :description,
    :finished?,
    :id,
    :csv,
    :raw_inputs,
    :source,
    :state,
    to: :import
  )

  def initialize(import)
    @import = import
  end

  def name
    "#{source.name} import: #{id}"
  end

  def total_count
    raw_inputs.count
  end

  def created_count
    raw_inputs.where(state: RawInput::CREATED).count
  end

  def updated_count
    raw_inputs.where(state: RawInput::UPDATED).count
  end

  def error_count
    raw_inputs.where(state: RawInput::ERROR).count
  end

  def exported_errors_url
    return nil unless import.finished? && error_count.positive?
    bucket = Rails.application.secrets.aws_bucket
    "https://#{bucket}.s3.amazonaws.com/errors/#{id}.csv"
  end

  def as_json(_)
    {
      state: state,
      total_count: total_count,
      created_count: created_count,
      updated_count: updated_count,
      error_count: error_count,
      exported_errors_url: exported_errors_url
    }
  end
end
