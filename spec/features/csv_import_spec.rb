require 'rails_helper'

feature 'CSV Import' do
  scenario 'Import one complete gallery' do
    Fabricate :tag, name: 'design'
    Fabricate :tag, name: 'modern'
    source = Fabricate :source, name: 'Factual'

    visit '/imports/new'

    select source.name, from: 'Source'
    fill_in 'File', with: 'spec/fixtures/one_complete_gallery.csv'
    fill_in 'Description', with: 'Monthly Data Import'

    click_button 'Create'

    expect(source.imports.count).to eq 1
    import = source.imports.first
    expect(page).to have_text "Factual import ##{import.id} (finished)"
    expect(page).to have_text import.description

    actual_counts = page.all('td + td').map(&:text)
    expected_counts = %w(1 1 0 0)
    expect(actual_counts).to eq expected_counts
  end
end
