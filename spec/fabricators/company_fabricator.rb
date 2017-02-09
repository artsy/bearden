Fabricator :company do
  name { Fabricate.sequence(:tag_name) { |i| "Company ##{i}" } }
end
