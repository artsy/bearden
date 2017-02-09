Fabricator :address do
  address { Fabricate.sequence(:address) { |i| "Street address ##{i}" } }
end
