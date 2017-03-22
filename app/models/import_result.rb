class ImportResult
  attr_reader :import

  delegate :description, :id, :raw_inputs, :source, to: :import

  def initialize(import)
    @import = import
  end

  def name
    "#{source.name} import ##{id}"
  end

  def status
    raw_inputs.where(state: nil).count.zero? ? 'finished' : 'in-progress'
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
end
