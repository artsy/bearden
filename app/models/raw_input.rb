class RawInput < ApplicationRecord
  belongs_to :import

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
end
