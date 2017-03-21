# rubocop:disable all

require_relative './burden_csv'

# Use a CSV with Burden IDs to create a new CSV with complementary data from Burden
#
# Usage:
# From within a Burden `gris console`:
#
# load '/full/path/to/enrich_outsourcer_csv.rb'
# input_file = "/Users/lancew/Code/bearden/data/outsourcers/artist-rosters/01/artist-rosters-batch-1-combined.csv"
# EnrichOutsourcerCSV.create_burden_csv(input_file)

class EnrichOutsourcerCSV
  def self.create_burden_csv(input_file)
    new(input_file).create_burden_csv
  end

  def initialize(input_file)
    @input_file = input_file
  end

  def create_burden_csv
    CSV.foreach(@input_file, headers: true).with_index(1) do |input, lineno|
      next if input['id'].nil?
      puts "#{lineno}: #{input}"
      BurdenCSV.export_row(
        query: { id: input['id'] },
        location: output_file,
        write_headers: lineno == 1,
        id: input['website']
      )
    end
  end

  private

  def output_file
    path = @input_file.split('/')
    file_name = path.pop
    (path << "burden-complement-#{file_name}").join('/')
  end

end
