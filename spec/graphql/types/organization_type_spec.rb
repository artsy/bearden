require 'rails_helper'

describe BeardenSchema.types['Organization'] do
  it 'is called Organization' do
    expect(described_class.name).to eq('Organization')
  end

  it {
    is_expected.to have_graphql_fields(
      :id,
      :names
    )
  }
end
