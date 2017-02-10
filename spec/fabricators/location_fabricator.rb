Fabricator :location do
  address1 { Fabricate.sequence(:address1) { |i| "Street address ##{i}" } }
end
