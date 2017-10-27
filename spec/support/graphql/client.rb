require 'graphlient'

RSpec.shared_context 'GraphQL Client', shared_context: :metadata do
  let(:jwt_token) do
    JWT.encode(
      { aud: Rails.application.secrets.artsy_application_id, roles: 'trusted' },
      Rails.application.secrets.artsy_internal_secret
    )
  end
  let(:auth_headers) { { 'Authorization' => "Bearer #{jwt_token}" } }
  let(:client) do
    Graphlient::Client.new('https://bearden-test.artsy.net/api/graphql', headers: auth_headers) do |client|
      client.http do |h|
        h.connection do |c|
          c.use Faraday::Adapter::Rack, app
        end
      end
    end
  end
end
