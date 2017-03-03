require 'csv'

desc 'Export csv file of organizations'
task export_csv: :environment do
  resolved = Organization.all.map(&OrganizationResolver.method(:resolve))
  converted = resolved.map(&CsvConverter.method(:convert))

  timestamp = Time.now.strftime('%F%T').gsub(/[^0-9a-z ]/i, '')
  filename = "export_#{timestamp}.csv"

  options = {
    headers: CsvConverter.headers,
    write_headers: true
  }

  CSV.open(filename, 'w', options) do |csv|
    converted.each { |row| csv << row }
  end

  puts "#{converted.count} Organizations exported to #{filename}"
end
