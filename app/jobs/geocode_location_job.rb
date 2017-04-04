class GeocodeLocationJob < ApplicationJob
  JOB_DELAY = 0.2.seconds
  FALLBACK_COORDINATES = [0.0, 0.0].freeze
  FALLBACK_COUNTRY, FALLBACK_CITY = nil

  def perform(import_id)
    @import_id = import_id
    location = next_location
    return unless location
    geocode(location) if location&.geocodable?
    enqueue_next_job
  end

  private

  def geocode(location)
    result = Geocoder.search(location.content)
    if result
      save_result(location, result.first)
    else
      save_fallback(location)
    end
  end

  def save_fallback(location)
    import = Import.find @import_id
    PaperTrail.track_changes_with(import) do
      location.update_attributes(
        latitude: FALLBACK_COORDINATES[0],
        longitude: FALLBACK_COORDINATES[1],
        country: FALLBACK_COUNTRY,
        city: FALLBACK_CITY
      )
    end
  end

  def save_result(location, result)
    import = Import.find @import_id
    PaperTrail.track_changes_with(import) do
      location.update_attributes(
        latitude: result.coordinates[0],
        longitude: result.coordinates[1],
        country: result.country,
        city: result.city
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
