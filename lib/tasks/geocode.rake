desc 'Create coordinates for records that are not geocoded'
task geocode_locations: :environment do
  source = Source.find_by name: 'Geocoder'
  description = "Geocoded by rake task on #{DateTime.now}"
  import = source.imports.create description: description
  GeocodeLocationJob.perform_now import.id
  puts 'Starting background process to geocode locations ...'
end
