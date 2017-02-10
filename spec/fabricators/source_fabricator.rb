Fabricator :source do
  name { Fabricate.sequence(:name) { |i| "Source ##{i}" } }
end
