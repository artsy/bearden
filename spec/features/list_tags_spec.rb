require 'rails_helper'

feature 'List Tags' do
  scenario 'Importer views list of tags' do
    tag_names = %w(design modern museum)
    tag_names.each { |name| Fabricate :tag, name: name }
    visit '/tags'
    tag_names.each { |name| expect(page).to have_text name }
  end
end
