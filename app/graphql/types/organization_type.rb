Types::OrganizationType = GraphQL::ObjectType.define do
  name 'Organization'

  field :id, !types.ID
  field :names, !types[types.String]
end
