require 'csv'
require 'open-uri'

desc 'Import csv file (run without args for allowed headers)'
task :import_csv, [:source_name, :url] => :environment do |_, args|
  if args.any?
    url = args[:url]
    stringio = open(url)
    stringio.set_encoding Encoding::UTF_8
    data = stringio.read

    source = Source.find_by name: args[:source_name]
    abort 'Source not found' unless source
    import = source.imports.create(
      description: "importing file: #{url}",
      transformer: CsvTransformer
    )

    csv = CSV.parse(data, headers: true)

    puts "Records queued to be imported: #{csv.length}"

    csv.each do |row|
      import.raw_inputs.create data: row.to_h
    end

    RawInputTransformJob.perform_later(import.id)
  else
    puts 'allowed headers:', CsvTransformer.allowed_headers
  end
end
