require 'typhoeus/adapters/faraday'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: Rails.application.secrets.elasticsearch_url,
  log: true,
  transport_options: {
    request: {
      timeout: ENV['ELASTICSEARCH_READ_TIMEOUT'].to_i || 30,
      open_timeout: ENV['ELASTICSEARCH_OPEN_TIMEOUT'].to_i || 30
    }
  }
)
