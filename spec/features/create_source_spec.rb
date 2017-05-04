require 'rails_helper'

feature 'Create Source' do
  before do
    allow_any_instance_of(SourcesController)
      .to receive(:admin?).and_return(false)
  end

  context 'with a non-admin user' do
    scenario 'Importer creates source' do
      visit '/sources/new'

      fill_in 'Name', with: 'Clearbit'

      select '1 - add to end', from: 'Email rank'
      select '1 - add to end', from: 'Location rank'
      select '1 - add to end', from: 'Organization name rank'
      select '1 - add to end', from: 'Organization type rank'
      select '1 - add to end', from: 'Phone number rank'
      select '1 - add to end', from: 'Website rank'

      click_button 'Create'

      source = Source.first
      expect(source.email_rank).to eq 1
      expect(source.location_rank).to eq 1
      expect(source.organization_name_rank).to eq 1
      expect(source.organization_type_rank).to eq 1
      expect(source.phone_number_rank).to eq 1
      expect(source.website_rank).to eq 1
    end

    scenario 'Importer creates better source than existing one' do
      source = Fabricate(
        :source,
        email_rank: 1,
        location_rank: 1,
        organization_name_rank: 1,
        organization_type_rank: 1,
        phone_number_rank: 1,
        website_rank: 1
      )

      visit '/sources/new'

      fill_in 'Name', with: 'Clearbit'

      select "1 - insert above #{source.name}", from: 'Email rank'
      select "1 - insert above #{source.name}", from: 'Location rank'
      select "1 - insert above #{source.name}", from: 'Organization name rank'
      select "1 - insert above #{source.name}", from: 'Organization type rank'
      select "1 - insert above #{source.name}", from: 'Phone number rank'
      select "1 - insert above #{source.name}", from: 'Website rank'

      click_button 'Create'

      expect(source.reload.email_rank).to eq 2
      expect(source.location_rank).to eq 2
      expect(source.organization_name_rank).to eq 2
      expect(source.organization_type_rank).to eq 2
      expect(source.phone_number_rank).to eq 2
      expect(source.website_rank).to eq 2

      new_source = Source.find_by name: 'Clearbit'
      expect(new_source.email_rank).to eq 1
      expect(new_source.location_rank).to eq 1
      expect(new_source.organization_name_rank).to eq 1
      expect(new_source.organization_type_rank).to eq 1
      expect(new_source.phone_number_rank).to eq 1
      expect(new_source.website_rank).to eq 1
    end
  end
end
