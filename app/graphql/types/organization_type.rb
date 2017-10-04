Types::OrganizationType = GraphQL::ObjectType.define do
  name 'Organization'

  field :id, !types.ID
  field :names, !types[types.String]
  field :tag_names, types[types.String]
  field :website_urls, types[types.String]
  field :cities, types[types.String]
  field :countries, types[types.String]
  field :in_business, types.Boolean
end
