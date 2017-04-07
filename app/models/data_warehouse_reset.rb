class DataWarehouseReset
  def self.run
    new.run
  end

  def run
    objects = []

    Organization.in_batches(of: 10_000).each_with_index do |relation, index|
      resolved = relation.map(&OrganizationResolver.method(:resolve))
      rows = resolved.map(&CsvConverter.method(:convert))
      file = filename(index)
      options = { rows: rows, filename: file, headers: headers }
      object = S3CsvExport.create(options)
      objects << object
    end

    DataWarehouse.reset(objects)
  end

  private

  def filename(index)
    @timestamp ||= Time.now.strftime('%F%T').gsub(/[^0-9a-z ]/i, '')
    "data_warehouse_reset/#{@timestamp}/#{index}.csv"
  end

  def headers
    CsvConverter.headers
  end
end
