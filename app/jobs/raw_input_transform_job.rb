class RawInputTransformJob < ActiveJob::Base
  def perform(raw_input_id)
    raw_input = RawInput.find(raw_input_id)
    attrs = raw_input.transform

    PaperTrail.with_actor(raw_input) do
      organization = Organization.create
      organization.locations.create attrs[:location]
      organization.organization_names.create attrs[:organization_name]
      organization.websites.create attrs[:website]
      raw_input.record_result 'created', organization
    end
  end
end
