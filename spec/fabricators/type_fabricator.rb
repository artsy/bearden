Fabricator :type do
  name { Fabricate.sequence(:type_name) { |i| "type ##{i}" } }
end
