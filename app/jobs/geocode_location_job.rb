class GeocodeLocationJob < ApplicationJob
  JOB_DELAY = 0.2.seconds
  FALLBACK_COORDINATES = [0.0, 0.0].freeze

  def perform
    location = next_location
    return enqueue_next unless location&.geocodable?
    geocode location
    return unless enqueue_next_job
  end

  private

  def geocode(location)
    coordinates = Geocoder.coordinates(location.content) || FALLBACK_COORDINATES
    location.update_attributes(
      latitude: coordinates[0],
      longitude: coordinates[1]
    )
  end

  def enqueue_next_job
    location = next_location
    return nil unless location
    GeocodeLocationJob.set(wait: JOB_DELAY).perform_later
  end

  def next_location
    Location.where('latitude IS NULL OR longitude IS NULL').first
  end
end
