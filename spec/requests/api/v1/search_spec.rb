require 'rails_helper'

describe 'GET /v1/search' do
  context 'with no token' do
    it 'returns a 401 with an error message' do
      get '/v1/search', as: :json
      expect(response.code).to eq '401'
      expect(response.body).to eq 'auth is wrong'
    end
  end

  context 'with an invalid token' do
    it 'returns a 401 with an error message' do
      headers = { 'Authorization' => 'invalid' }
      get '/v1/search', headers: headers, as: :json
      expect(response.code).to eq '401'
      expect(response.body).to eq 'auth is wrong'
    end
  end

  context 'with a good token' do
    let(:jwt_token) do
      JWT.encode(
        { aud: Rails.application.secrets.artsy_application_id },
        Rails.application.secrets.artsy_internal_secret
      )
    end

    let(:headers) { { 'Authorization' => "Bearer #{jwt_token}" } }

    context 'with no term' do
      it 'returns a 400 with an error message' do
        get '/v1/search', headers: headers, as: :json

        expect(response.code).to eq '400'
        expect(response.body).to eq 'no term parameter'
      end
    end

    context 'with a valid term' do
      it 'returns the matches for that term' do
        Organization.recreate_index!
        organization = Fabricate :organization
        Fabricate :organization_name, organization: organization, content: 'David Zwirner Gallery'
        organization.es_index
        Organization.refresh_index!

        get '/v1/search', params: { term: 'David' }, headers: headers, as: :json

        expect(response.code).to eq '200'
        response_json = JSON.parse(response.body)
        expect(response_json).to eq(
          [
            {
              'names' => organization.names,
              'tag_names' => organization.tag_names,
              'website_urls' => organization.website_urls,
              'cities' => organization.cities,
              'countries' => organization.countries,
              'id' => organization.id,
              'in_business' => organization.in_business
            }
          ]
        )
      end
    end
  end
end
