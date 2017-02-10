Fabricator :organization do
  name { Fabricate.sequence(:tag_name) { |i| "Organization ##{i}" } }
end
