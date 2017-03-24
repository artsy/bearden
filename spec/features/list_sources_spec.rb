require 'rails_helper'

feature 'List Sources' do
  scenario 'Importer views list of sources' do
    sources = Fabricate.times 3, :source
    visit '/sources'
    sources.each { |source| expect(page).to have_text source.name }
  end
end
