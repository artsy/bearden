class LocationsGeocodeJob < ApplicationJob
  def perform(location_id)
    location = Location.find_by id: location_id
    return unless location&.geocodable?

    begin
      coordinates = Geocoder.coordinates(location.content)

      unless coordinates
        logger.warn "Could not geocode Location: #{location.id}"
        return
      end

      location.update_attributes latitude: coordinates[0], longitude: coordinates[1]

      next_location = Location.where(latitude: nil).or(Location.where(longitude: nil)).first
      self.class.set(wait: 0.2.seconds).perform_later(next_location.id) if next_location

    rescue Geocoder::OverQueryLimitError
      logger.warn "Geocoder is over its query limit"
    end
  end
end
