Fabricator :website do
  content { Fabricate.sequence(:website) { |i| "https://example#{i}.com" } }
end
