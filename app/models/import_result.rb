class ImportResult
  attr_reader :import

  delegate :description, :id, :raw_inputs, :source, :state, to: :import

  def initialize(import)
    @import = import
  end

  def name
    "#{source.name} import ##{id}"
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

  def as_json(_)
    {
      state: state,
      total_count: total_count,
      created_count: created_count,
      updated_count: updated_count,
      error_count: error_count
    }
  end
end
