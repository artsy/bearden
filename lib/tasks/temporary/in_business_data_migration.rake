desc 'Covert in_business to a string'
task in_business_data_migration: :environment do
  Organization.where(in_business: 'false').update_all(in_business: Organization::CLOSED)
  Organization.where(in_business: 'true').update_all(in_business: Organization::UNKNOWN)

  source = Source.find_by name: 'HumanOutsourcer'

  PaperTrail.track_changes_with('data migration') do
    for raw_input in source.imports.flat_map(&:raw_inputs)
      next unless raw_input.output_type == 'Organization'
      organization = Organization.find_by id: raw_input.output_id
      organization.update_attributes in_business: Organization::OPEN
    end
  end
end
