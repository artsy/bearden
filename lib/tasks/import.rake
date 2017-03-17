require 'csv'
require 'open-uri'

desc 'Import csv file (run without args for allowed headers)'
task :import_csv, [:source_name, :uri] => :environment do |_, args|
  if args.any?
    source_name = args[:source_name]
    uri = args[:uri]
    abort 'Please specify both a Source name and URI.' unless source_name && uri

    source = Source.find_by name: source_name
    abort 'Source not found.' unless source

    begin
      stringio = open(uri)
    rescue OpenURI::HTTPError
      abort 'URI could not be opened.'
    end

    stringio.set_encoding Encoding::UTF_8
    data = stringio.read

    import = source.imports.create(
      description: "importing file: #{uri}",
      transformer: CsvTransformer
    )

    csv = CSV.parse(data, headers: true)
    csv.each { |row| import.raw_inputs.create data: row.to_h }
    RawInputTransformJob.perform_later(import.id)

    puts "Records queued to be imported: #{csv.length}"
  else
    puts 'allowed headers:', CsvTransformer.allowed_headers
  end
end
