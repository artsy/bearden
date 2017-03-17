# rubocop:disable all

# Usage:
# From a Burden `gris console`:
#
# load '/path/to/this/file.rb'
# input_file = "/Users/lancew/Code/bearden/data/outsourcers/artist-rosters/01/artist-rosters-batch-1-combined.csv"
# output_file = "/Users/lancew/Code/bearden/data/outsourcers/artist-rosters/01/burden-artist-rosters-batch-1-combined.csv"
# EnrichOutsourcerCSV.create_burden_csv(input_file, output_file)

class EnrichOutsourcerCSV
  def create_burden_csv(input_file, output_file)
    new(input_file, output_file).create_burden_csv
  end

  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
  end

  def self.create_burden_csv
    CSV.open(input_file, headers: true).each do |input|
      next if input['id'].nil?
      puts input
      BurdenCSV.export_row(
        query: { id: input['id'] },
        location: output_file
      )
    end
  end
end
