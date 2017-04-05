ArtsyAuth.configure do |config|
  config.artsy_api_url = Rails.application.secrets.artsy_api_url
  config.callback_url = '/imports' # optional
  config.application_id = Rails.application.secrets.artsy_application_id
  config.application_secret = Rails.application.secrets.artsy_application_secret
end
