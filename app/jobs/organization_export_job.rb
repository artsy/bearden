class OrganizationExportJob < ApplicationJob
  queue_as :export

  PART_SIZE = Rails.application.secrets.batch_export_size

  attr_accessor :sync, :part_number, :part_size

  def perform(sync_id, part_number)
    @sync = Sync.find_by id: sync_id
    @part_number = part_number
    return unless sync

    S3CsvExport.create(export_options)
    sync.increment_uploaded_parts
  end

  private

  def export_options
    {
      rows: rows,
      filename: filename,
      headers: headers
    }
  end

  def rows
    offset = (part_number - 1) * PART_SIZE
    organizations = Organization.order(:id).offset(offset).limit(PART_SIZE)
    resolved = organizations.map(&OrganizationResolver.method(:resolve))
    resolved.map(&CsvConverter.method(:convert))
  end

  def filename
    "#{sync.export_folder}/#{part_number}.csv"
  end

  def headers
    CsvConverter.headers
  end
end
