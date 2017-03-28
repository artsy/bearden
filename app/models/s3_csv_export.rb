class S3CsvExport
  def self.create(rows, filename, headers)
    new(rows, filename, headers).create
  end

  def initialize(rows, filename, headers)
    @rows = rows
    @filename = filename
    @headers = headers
  end

  def create
    object = s3_bucket.object(@filename)
    object.put acl: 'public-read', body: csv_data
    object
  end

  private

  def s3_bucket
    Aws::S3::Resource.new.bucket ENV['AWS_BUCKET']
  end

  def csv_data
    CSV.generate(csv_options) do |csv|
      @rows.each { |row| csv << row }
    end
  end

  def csv_options
    { headers: @headers, write_headers: true }
  end
end
