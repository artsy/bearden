class RawInput < ApplicationRecord
  belongs_to :import

  CREATED = 'created'.freeze
  UPDATED = 'updated'.freeze
  ERROR = 'error'.freeze

  def transform
    import.transformer.constantize.transform self
  end

  def record_result(result, output)
    update_attributes(
      result: result,
      output_id: output.id,
      output_type: output.class
    )
  end

  def record_error(error)
    update_attributes(
      result: ERROR,
      exception: error
    )
  end
end
