require 'csv'

desc 'Export csv file of organizations'
task export_csv: :environment do
  resolved = Organization.all.map(&OrganizationResolver.method(:resolve))
  rows = resolved.map(&CsvConverter.method(:convert))

  timestamp = Time.now.strftime('%F%T').gsub(/[^0-9a-z ]/i, '')
  filename = "exports/#{timestamp}.csv"
  headers = CsvConverter.headers

  object = S3CsvExport.create(rows, filename, headers)

  puts "#{rows.count} Organizations exported to #{object.public_url}"
end
