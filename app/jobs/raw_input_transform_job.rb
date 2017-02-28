class RawInputTransformJob < ActiveJob::Base
  def perform(raw_input_id)
    raw_input = RawInput.find_by id: raw_input_id
    return unless raw_input
    RawInputChanges.apply raw_input
  end
end
