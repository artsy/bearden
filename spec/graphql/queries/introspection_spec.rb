require 'rails_helper'

describe 'GraphQL Introspection', type: :request do
  include_context 'GraphQL Client'

  it 'requires a token' do
    post '/api/graphql'
    expect(response.status).to eq 403
  end
  it 'requires a valid token' do
    post '/api/graphql', headers: { 'Authorization' => 'invalid' }
    expect(response.status).to eq 403
  end
  it 'retrieves schema' do
    expect(client.schema).to be_a GraphQL::Schema
  end
end
