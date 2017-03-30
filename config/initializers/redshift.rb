module Redshift
  SCHEMA = 'bearden_exports'.freeze
  SCHEMA_TABLE = 'bearden_exports.organizations'.freeze

  def self.connect
    conn = connection
    yield conn
  ensure
    conn.close
  end

  def self.connection
    PG.connect(Rails.application.secrets.redshift_settings)
  end
end
