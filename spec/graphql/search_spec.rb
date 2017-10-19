require 'rails_helper'

describe GraphqlController, type: :controller do
  let(:jwt_token) do
    JWT.encode(
      { aud: Rails.application.secrets.artsy_application_id, roles: 'trusted' },
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
        Organization.recreate_index!
        post :execute, params: { query: '{ search(term: "x") { id } }' }
        expect(response.status).to eq 200
        expect(response.body).to eq '{"data":{"search":[]}}'
      end
      it 'requires term' do
        post :execute, params: { query: '{ search() { id } }' }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['errors'].first['message']).to eq "Field 'search' is missing required arguments: term"
      end
      context 'with an organization' do
        let!(:organization) { Fabricate :organization }
        let!(:organization_name) { Fabricate :organization_name, organization: organization, content: 'David Zwirner Gallery' }
        before do
          allow_any_instance_of(OrganizationName).to receive(:rank).and_return(1)
          Organization.recreate_index!
          organization.es_index
          Organization.refresh_index!
        end
        it 'returns organizations' do
          post :execute, params: { query: '{ search(term: "David") { name } }' }
          expect(response.status).to eq 200
          expect(response.body).to eq '{"data":{"search":[{"name":"David Zwirner Gallery"}]}}'
        end
      end
      context 'with multiple organizations' do
        before do
          3.times do |i|
            organization_name = Fabricate(:organization_name, organization: Fabricate(:organization), content: "David #{i}")
            allow_any_instance_of(OrganizationName).to receive(:rank).and_return(1)
            organization_name.organization.es_index
          end
          Organization.recreate_index!
          Organization.refresh_index!
        end
        it 'returns all organizations' do
          post :execute, params: { query: '{ search(term: "David") { name } }' }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data']['search'].count).to eq 3
        end
        it 'can return a max number of organizations' do
          post :execute, params: { query: '{ search(term: "David", first: 2) { name } }' }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data']['search'].count).to eq 2
        end
      end
      context 'with multiple organization names' do
        let!(:organization) { Fabricate :organization }
        let!(:alt_name) { Fabricate(:organization_name, organization: organization, content: 'Joe Bloggs') }
        let!(:name) { Fabricate(:organization_name, organization: organization, content: 'David Zwirner') }
        before do
          allow_any_instance_of(OrganizationName).to receive(:rank).and_return(1)
          name.organization.es_index
          Organization.refresh_index!
        end
        it 'searches alternate names but returns original one' do
          post :execute, params: { query: '{ search(term: "Joe") { name } }' }
          expect(response.status).to eq 200
          expect(response.body).to eq '{"data":{"search":[{"name":"Joe Bloggs"}]}}'
        end
      end
    end
  end
end
