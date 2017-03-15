class RawInputErrorsJob < ApplicationJob
  def perform
    raw_inputs_with_errors = RawInput.where state: RawInput::ERROR
    return unless raw_inputs_with_errors.count.positive?

    raw_inputs_with_errors.each do |raw_input|
      RawInputChanges.apply raw_input
    end
  end
end
