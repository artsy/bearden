desc 'Create coordinates for records that are not geocoded'
task geocode_locations: :environment do
  import = Import.create(
    description: "Geocoded by rake task on #{DateTime.now}",
    source: Location.geocoder_source)
  GeocodeLocationJob.perform_now import

  puts 'Starting background process to geocode locations ...'
end
