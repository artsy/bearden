Fabricator :tag do
  name { Fabricate.sequence(:tag_name) { |i| "tag ##{i}" } }
end
