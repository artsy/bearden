require 'rails_helper'

describe 'GET /v1/ping' do
  it 'returns an empty 200 response' do
    get '/v1/ping'

    expect(response.code).to eq '200'
    expect(JSON.parse(response.body)).to eq({ 'timestamp' => Time.now.to_i })
  end
end
