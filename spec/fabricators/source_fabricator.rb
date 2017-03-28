Fabricator :source do
  name { Fabricate.sequence(:name) { |i| "Source ##{i}" } }
  email_rank { Fabricate.sequence(:email_rank, 1) }
  location_rank { Fabricate.sequence(:location_rank, 1) }
  organization_name_rank { Fabricate.sequence(:organization_name_rank, 1) }
  phone_number_rank { Fabricate.sequence(:phone_number_rank, 1) }
  website_rank { Fabricate.sequence(:website_rank, 1) }
end
