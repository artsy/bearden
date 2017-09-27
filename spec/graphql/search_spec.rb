require 'rails_helper'

describe GraphqlController, type: :controller do
  describe 'execute' do
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
