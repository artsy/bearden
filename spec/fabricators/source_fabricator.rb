Fabricator :source do
  name { Fabricate.sequence(:name) { |i| "Source ##{i}" } }
  rank { Fabricate.sequence(:rank) }
end
