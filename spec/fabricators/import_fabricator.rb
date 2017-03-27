Fabricator :import do
  source { Fabricate :source }
  state ImportMicroMachine::UNSTARTED
  uri 'http://example.com/import.csv'
end
