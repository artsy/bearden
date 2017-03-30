class DataWarehouseReset
  def self.run
    new.run
  end

  def run
    object = S3CsvExport.create(s3_options)
    DataWarehouse.reset(object)
  end

  private

  def s3_options
    {
      rows: rows,
      filename: filename,
      headers: headers
    }
  end

  def rows
    resolved = Organization.all.map(&OrganizationResolver.method(:resolve))
    resolved.map(&CsvConverter.method(:convert))
  end

  def filename
    timestamp = Time.now.strftime('%F%T').gsub(/[^0-9a-z ]/i, '')
    "data_warehouse_reset/#{timestamp}.csv"
  end

  def headers
    CsvConverter.headers
  end
end
