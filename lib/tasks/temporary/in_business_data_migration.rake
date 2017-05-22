namespace :temporary do
  desc 'Convert in_business to a string'
  task in_business_data_migration: :environment do
    PaperTrail.track_changes_with('data migration') do
      Organization.where(in_business: 'false').update_all(in_business: Organization::CLOSED)
      Organization.where(in_business: 'true').update_all(in_business: Organization::UNKNOWN)

      source = Source.find_by name: 'HumanOutsourcer'
      raw_inputs = source.imports.flat_map(&:raw_inputs)

      in_business_raw_inputs = raw_inputs.select do |raw_input|
        raw_input.output_id && !raw_input.data['in_business'].nil?
      end

      organization_ids = in_business_raw_inputs.map(&:output_id)
      Organization.where.not(in_business: Organization::CLOSED).where(id: organization_ids).update_all(in_business: Organization::OPEN)
    end
  end
end
