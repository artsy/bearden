require 'csv'

desc 'Import csv file'
task :import_csv, [:url] => :environment do |_, args|
  url = args[:url]
  # this will end up being a Faraday call to grab the content of the url
  data = File.read url

  source = Source.find_by name: 'rake'
  import = source.imports.create(
    description: "importing file: #{url}",
    transformer: CsvImportTransformer
  )

  CSV.parse(data, headers: true) do |row|
    input = import.raw_inputs.create data: row.to_h
    RawInputTransformJob.perform_later input.id
  end

  puts "import #{import.id}"
end
