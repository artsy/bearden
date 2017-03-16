Fabricator :email do
  content { sequence(:email) { |i| "user#{i}@example.com" } }
end
