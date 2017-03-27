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
      open(uri)
    rescue OpenURI::HTTPError
      abort 'URI could not be opened.'
    end

    import = source.imports.create(
      description: "importing file: #{uri}",
      state: ImportMicroMachine::UNSTARTED,
      transformer: CsvTransformer,
      uri: uri
    )

    ParseCsvImportJob.perform_later(import.id)

    puts "Import ##{import.id} created."
  else
    puts 'allowed headers:', CsvTransformer.allowed_headers
  end
end
