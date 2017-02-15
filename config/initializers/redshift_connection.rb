module RedshiftConnection
  DB = Sequel.connect(
    ENV['REDSHIFT_DB_URL'],
    force_standard_strings: false,
    client_min_messages: ''
  )
end
