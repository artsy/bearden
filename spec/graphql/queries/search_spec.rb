require 'rails_helper'

describe GraphqlController, type: :request do
  include_context 'GraphQL Client'
  let(:query) do
    <<~GRAPHQL
      query($term: String!, $first: Int = 20) {
        search(term: $term, first: $first) {
          id
          name
        }
      }
    GRAPHQL
  end

  it 'runs a query' do
    Organization.recreate_index!
    response = client.query(query, term: 'x')
    expect(response.data.search).to eq([])
  end
  it 'requires term' do
    expect do
      client.query '{ search() { id } }'
    end.to raise_error Graphlient::Errors::ClientError, "Field 'search' is missing required arguments: term"
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
      response = client.execute(query, term: 'David')
      expect(response.data.search.map(&:name)).to eq ['David Zwirner Gallery']
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
      response = client.execute(query, term: 'David')
      expect(response.data.search.count).to eq 3
    end
    it 'can return a max number of organizations' do
      response = client.execute(query, term: 'David', first: 2)
      expect(response.data.search.count).to eq 2
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
      response = client.execute(query, term: 'Joe')
      expect(response.data.search.map(&:name)).to eq ['Joe Bloggs']
    end
  end
end
