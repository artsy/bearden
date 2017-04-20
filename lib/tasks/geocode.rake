desc 'Create coordinates for records that are not geocoded'
task geocode_locations: :environment do
  GeocodeLocationJob.perform_now
end
