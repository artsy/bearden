require 'rails_helper'

describe BeardenSchema.types['Query'] do
  it 'is called Query' do
    expect(described_class.name).to eq('Query')
  end

  it { is_expected.to have_graphql_fields(:search) }
end
