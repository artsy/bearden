Fabricator :organization do
  website { Fabricate.sequence(:website) { |i| "https://example#{i}.com" } }
end
