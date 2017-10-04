require 'rails_helper'

describe GraphqlController, type: :controller do
  let(:jwt_token) do
    JWT.encode(
      { aud: Rails.application.secrets.artsy_application_id },
      Rails.application.secrets.artsy_internal_secret
    )
  end
  describe 'execute' do
    it 'requires a token' do
      post :execute
      expect(response.status).to eq 401
      expect(response.body).to eq 'Access Denied'
    end
    context 'with auth' do
      let(:auth_headers) { { 'Authorization' => "Bearer #{jwt_token}" } }
      before do
        request.headers.merge! auth_headers
      end
      it 'runs a query' do
        post :execute, params: { query: '{ search(term: "x") { id } }' }
        expect(response.status).to eq 200
        expect(response.body).to eq '{"data":{"search":[]}}'
      end
      it 'requires term' do
        post :execute, params: { query: '{ search() { id } }' }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['errors'].first['message']).to eq "Field 'search' is missing required arguments: term"
      end
      context 'with organizations' do
        let!(:organization) { Fabricate :organization }
        let!(:organization_name) { Fabricate :organization_name, organization: organization, content: 'David Zwirner Gallery' }
        before do
          Organization.recreate_index!
          organization.es_index
          Organization.refresh_index!
        end
        it 'returns organizations' do
          post :execute, params: { query: '{ search(term: "David") { names } }' }
          expect(response.status).to eq 200
          expect(response.body).to eq '{"data":{"search":[{"names":["David Zwirner Gallery"]}]}}'
        end
      end
    end
  end
end
