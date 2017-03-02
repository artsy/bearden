require 'csv'

desc 'Export csv file of organizations'
task export_csv: :environment do
  resolved = Organization.all.map(&OrganizationResolver.method(:resolve))
  converted = CsvConverter.convert resolved

  filename = 'export.csv'

  options = {
    headers: CsvConverter.headers,
    write_headers: true
  }

  CSV.open(filename, 'w', options) do |csv|
    converted.each { |row| csv << row }
  end

  puts "#{converted.count} Organizations exported to #{filename}"
end
