class RawInputTransformJob < ActiveJob::Base
  def perform(raw_input_id)
    raw_input = RawInput.find(raw_input_id)
    attrs = raw_input.transform

    PaperTrail.with_actor(raw_input) do
      organization = Organization.create attrs[:organization]
      organization.locations.create attrs[:location]
      raw_input.record_result 'created', organization
    end
  end
end
