Fabricator :import do
  name { Fabricate.sequence(:name) { |i| "Import ##{i}" } }
  source { Fabricate :source }
end
