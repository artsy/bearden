require 'csv'

desc 'Export csv file of organizations'
task export_csv: :environment do
  resolved = Organization.all.map(&OrganizationResolver.method(:resolve))

  filename = 'export.csv'

  options = {
    headers: OrganizationResolver.headers,
    write_headers: true
  }

  CSV.open(filename, 'w', options) do |csv|
    resolved.each { |row| csv << row }
  end

  puts "#{resolved.count} Organizations exported to #{filename}"
end
