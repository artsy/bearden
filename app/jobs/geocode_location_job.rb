class GeocodeLocationJob < ApplicationJob
  FALLBACK_COORDINATES = [0.0, 0.0].freeze
  FALLBACK_COUNTRY = nil
  FALLBACK_CITY = nil
  JOB_DELAY = 0.2.seconds
  NO_RESULTS_FOUND = 'NO_RESULTS_FOUND'.freeze

  def perform
    location = next_location
    return unless location
    geocode(location)
    enqueue_next_job
  end

  private

  def geocode(location)
    results = Geocoder.search(location.content)

    PaperTrail.track_changes_with('Geocoder') do
      attrs = location_attrs(results&.first)
      location.update_attributes(attrs)
    end
  end

  def location_attrs(result)
    return fallback_attrs unless result

    {
      latitude: result.coordinates[0],
      longitude: result.coordinates[1],
      country: result.country,
      city: result.city,
      geocode_response: result
    }
  end

  def fallback_attrs
    {
      latitude: FALLBACK_COORDINATES[0],
      longitude: FALLBACK_COORDINATES[1],
      country: FALLBACK_COUNTRY,
      city: FALLBACK_CITY,
      geocode_response: NO_RESULTS_FOUND
    }
  end

  def enqueue_next_job
    GeocodeLocationJob.set(wait: JOB_DELAY).perform_later
  end

  def next_location
    Location.where(geocode_response: nil).first
  end
end
