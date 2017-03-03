class LocationsGeocodeJob < ApplicationJob
  def perform(location_id)
    location = Location.find_by id: location_id
    return unless location&.geocodable?
    begin
      geocode location
      next_location
    rescue Geocoder::OverQueryLimitError
      logger.warn 'Geocoder has exceeded its query limit'
    end
  end

  def geocode(location)
    coordinates = Geocoder.coordinates(location.content)
    unless coordinates
      logger.warn "Geocoding <Location id: #{location.id}> failed"
      return
    end
    location.update_attributes(
      latitude: coordinates[0],
      longitude: coordinates[1]
    )
  end

  def next_location
    where_longitude_nil = Location.where(longitude: nil)
    location = Location.where(latitude: nil).or(where_longitude_nil).first
    return unless location
    self.class.set(wait: 0.2.seconds).perform_later(location.id)
  end
end
