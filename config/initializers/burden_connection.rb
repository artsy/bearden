module BurdenConnection
  DB = Sequel.connect(
    Rails.application.secrets.burden_db_url,
    force_standard_strings: false,
    client_min_messages: ''
  )
end
