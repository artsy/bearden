module BurdenConnection
  DB = Sequel.connect(
    ENV['BURDEN_DB_URL'],
    force_standard_strings: false,
    client_min_messages: ''
  )
end
