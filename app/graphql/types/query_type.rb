Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema.'

  field :search, !types[Types::OrganizationType] do
    argument :term, !types.String
    description 'Find organizations by name.'
    resolve lambda { |_obj, args, _ctx|
      Organization.estella_search(term: args['term'], size: 20)
    }
  end
end
