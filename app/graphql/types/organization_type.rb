Types::OrganizationType = GraphQL::ObjectType.define do
  name 'Organization'

  field :id, !types.ID
  field :name, !types.String
end
