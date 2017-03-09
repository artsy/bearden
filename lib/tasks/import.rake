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

    jobs_queued_count = 0

    CSV.parse(data, headers: true) do |row|
      input = import.raw_inputs.create data: row.to_h
      RawInputTransformJob.perform_later input.id
      jobs_queued_count += 1
    end

    puts "Records queued to be imported: #{jobs_queued_count}"
  else
    puts 'allowed headers:', CsvTransformer.allowed_headers
  end
end
