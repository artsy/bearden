require 'rails_helper'

feature 'List Types' do
  scenario 'Importer views list of types' do
    type_names = %w[gallery museum not_art_org]
    type_names.each { |name| Fabricate :type, name: name }
    visit '/types'
    type_names.each { |name| expect(page).to have_text name }
  end
end
