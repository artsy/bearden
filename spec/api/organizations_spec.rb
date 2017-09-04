require 'rails_helper'

describe Organizations::API, type: :request do
  let(:org) { Fabricate :organization }
  let(:org2) { Fabricate :organization }
  before do
    Organization.recreate_index!
    org.organization_names.create! content: 'Quux Gallery'
    org.save!
    org2.organization_names.create! content: 'David Zwirner Gallery'
    org2.save!
    Organization.refresh_index!
  end
  describe 'search api' do
    it 'searches organizations by name' do
      get '/api/v1/organizations/search?term=quux'
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.first['id']).to eq org.id
    end
    it 'autocompletes organizations by name' do
      get '/api/v1/organizations/search?term=quu'
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.first['id']).to eq org.id
    end
    it 'uses shingle analysis' do
      Organization.refresh_index!
      get '/api/v1/organizations/search?term=zwir'
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.first['id']).to eq org2.id
    end
    it 'boosts organizations by location count' do
      org3 = Fabricate :organization
      org3.organization_names.create! content: 'Quux Galerie'
      org3.locations.create!(city: 'Foo', country: 'Bar', content: 'Bar')
      org3.locations.create!(city: 'Foo2', country: 'Bar2', content: 'Bar')
      org3.save!
      Organization.refresh_index!
      get '/api/v1/organizations/search?term=quux'
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.first['id']).to eq org3.id
    end
  end
end
