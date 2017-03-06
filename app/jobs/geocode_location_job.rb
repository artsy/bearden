class GeocodeLocationJob < ApplicationJob
  def perform
    location = next_location
    return enqueue_next unless location&.geocodable?
    geocode location
    return unless enqueue_next_job
  end

  private

  def geocode(location)
    coordinates = Geocoder.coordinates(location.content)
    unless coordinates
      logger.warn "Geocoding <Location id: #{location.id}> failed"
      # TODO: As is, this will just continue to crash the job each time.
      # A better solution would be to fill coordinates lat and lon from
      # Antartica or something...
      raise Geocoder::InvalidRequest
    end
    location.update_attributes(
      latitude: coordinates[0],
      longitude: coordinates[1]
    )
  end

  def enqueue_next_job
    location = next_location
    return nil unless location
    GeocodeLocationJob.set(wait: 0.2.seconds).perform_later
  end

  def next_location
    Location.where('latitude IS NULL OR longitude IS NULL').first
  end
end
