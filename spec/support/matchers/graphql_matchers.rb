RSpec::Matchers.define :have_graphql_fields do |*expected|
  match do |kls|
    expect(kls.fields.keys).to contain_exactly(*expected.map(&:to_s))
  end
end
