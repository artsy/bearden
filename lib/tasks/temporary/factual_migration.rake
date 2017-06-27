namespace :temporary do
  desc 'Fill in city from old Factual imports'
  task factual_re_migration: :environment do
    factual_imports = [27, 28, 29]
    
    factual_imports.each do |import_id|
      raw_inputs = RawInput.where(import: import_id).where(exception: nil)

      raw_inputs.each do |raw_input|
        data = raw_input.data

        if data['locality'].present?
          locations = Location
            .where(latitude: data['latitude'])
            .where(longitude: data['longitude'])
            .where(city: nil)

          locations.each do |location|
            PaperTrail.track_changes_with('PR#274') do
              location.update_attribute(:city, data['locality'])
              puts "Updated Location(#{location.id}): City: #{data['locality']} from RawInput(#{raw_input.id})"
            end
          end
        end
      end
    end
  end
end
