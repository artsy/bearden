# rubocop:disable all

class Record
  def self.create(record)
    new(record).create
  end

  def initialize(record)
    @record = record
  end

  def create
    {
      website: @record[:website],
      location: @record[:location],
      latitude: @record[:latitude],
      longitude: @record[:longitude],
      email: @record[:email],
      phone_number: @record[:phone_number],
      organization_name: @record[:organization_name],
      burden_id: @record[:burden_id]
    }
  end
end


class BurdenCSV
  def self.export(query:, location:)
    new(query, location).export
  end

  def initialize(query, location)
    @query = query
    @location = location
  end

  def export
    headers = Record.create({}).keys.map(&:to_s)
    CSV.open(@location, 'wb', headers: headers, write_headers: true) do |csv|
      Organization.where(@query).each do |org|
        export_organization(org, csv)
        export_locations(org, csv) if org.locations_count > 1
        export_emails(org, csv) if org.email_addresses_count > 1
        export_phone_numbers(org, csv) if org.phone_numbers_count > 1
      end
    end
  end

  def export_organization(org, csv)
    org_row = Record.create(
      website: org.websites.first.host,
      burden_id: org.id,
      organization_name: org.name
    )
    csv << org_row.values
  end

  def export_locations(org, csv)
    org.locations.each do |location|
      location_row = Record.create(
        website: org.websites.first.host,
        burden_id: org.id,
        location: location.content,
        latitude: location.latitude,
        longitude: location.longitude
      )
      csv << location_row.values
    end
  end

  def export_emails(org, csv)
    emails = org.email_addresses
    emails.each do |email|
      email_row = Record.create(
        website: org.websites.first.host,
        burden_id: org.id,
        email: email.content
      )
      csv << email_row.values
    end
  end

  def export_phone_numbers(org, csv)
    phones = org.phone_numbers
    phones.each do |phone|
      phone_row = Record.create(
        website: org.websites.first.host,
        burden_id: org.id,
        phone_number: phone.content
      )
      csv << phone_row.values
    end
  end
end
