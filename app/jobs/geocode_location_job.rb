class GeocodeLocationJob < ApplicationJob
  JOB_DELAY = 0.2.seconds
  FALLBACK_COORDINATES = [0.0, 0.0].freeze

  def perform(import_id)
    @import_id = import_id
    location = next_location
    return unless location
    geocode(location) if location&.geocodable?
    enqueue_next_job
  end

  private

  def geocode(location)
    coordinates = Geocoder.coordinates(location.content) || FALLBACK_COORDINATES
    import = Import.find @import_id
    PaperTrail.track_changes_with(import) do
      location.update_attributes(
        latitude: coordinates[0],
        longitude: coordinates[1]
      )
    end
  end

  def enqueue_next_job
    GeocodeLocationJob.set(wait: JOB_DELAY).perform_later(@import_id)
  end

  def next_location
    Location.where('latitude IS NULL OR longitude IS NULL').first
  end
end
