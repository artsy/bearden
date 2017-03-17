# rubocop:disable all

bearden_dir = '/Users/lancew/Code/bearden'

input_file = "#{bearden_dir}/data/outsourcers/artist-rosters/01/artist-rosters-batch-1-combined.csv"
output_file = "#{bearden_dir}/data/outsourcers/artist-rosters/01/burden-artist-rosters-batch-1-combined.csv"

input_csv = CSV.open(input_file, headers: true)

input_csv.each do |input|
  next if input['id'].nil?
  puts input
  BurdenCSV.export_row(
    query: { id: input['id'] },
    location: output_file
  )
end
