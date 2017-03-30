require 'csv'

class S3CsvExport
  PUBLIC = 'public-read'.freeze
  PRIVATE = 'private'.freeze

  def self.create(rows:, filename:, headers:, acl: PRIVATE)
    new(rows, filename, headers, acl).create
  end

  def initialize(rows, filename, headers, acl)
    @rows = rows
    @filename = filename
    @headers = headers
    @acl = acl
  end

  def create
    object = s3_bucket.object(@filename)
    object.put acl: @acl, body: csv_data
    object
  end

  private

  def s3_bucket
    Aws::S3::Resource.new.bucket Rails.application.secrets.aws_bucket
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
