require 'rails_helper'

describe 'List Imports' do
  scenario 'Importer views list of imports' do
    source = Fabricate :source, name: 'Clearbit'
    imports = Fabricate.times 3, :import, source: source

    visit '/imports'

    imports.each do |import|
      expect(page).to have_text "Clearbit import ##{import.id}"
    end
  end
end
