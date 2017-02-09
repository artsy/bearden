Fabricator :tag do
  name { Fabricate.sequence(:tag_name) { |i| "Tag ##{i}" } }
end
