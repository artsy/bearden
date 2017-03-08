require 'csv'

desc 'Export csv file of organizations'
task export_csv: :environment do
  resolved = Organization.all.map(&OrganizationResolver.method(:resolve))
  converted = resolved.map(&CsvConverter.method(:convert))

  options = {
    headers: CsvConverter.headers,
    write_headers: true
  }

  csv_data = CSV.generate(options) do |csv|
    converted.each { |row| csv << row }
  end

  timestamp = Time.now.strftime('%F%T').gsub(/[^0-9a-z ]/i, '')
  filename = "export_#{timestamp}.csv"

  s3 = Aws::S3::Resource.new
  object = s3.bucket('bearden-staging').object(filename)
  object.put acl: 'public-read', body: csv_data

  puts "#{converted.count} Organizations exported to #{object.public_url}"
end
