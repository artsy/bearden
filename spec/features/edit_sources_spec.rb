require 'rails_helper'

feature 'Edit Source' do
  before do
    allow_any_instance_of(SourcesController)
      .to receive(:admin?).and_return(is_admin)
  end

  context 'with an admin' do
    let(:is_admin) { true }

    scenario 'Admins have access to edit a source' do
      Fabricate(:source)

      allow_any_instance_of(ApplicationController)
        .to receive(:user).and_return(
          {
            uid: 'foo',
            roles: %w[admin foo]
          }
        )

      visit '/sources'
      expect(page).to have_css 'a.edit'
    end
  end

  context 'with a non-admin' do
    let(:is_admin) { false }

    scenario 'Non-admins do not have access to create a new source' do
      Fabricate(:source)
      visit '/sources'
      expect(page).to_not have_css 'a.edit'
    end

    scenario 'Importer edits source' do
      allow_any_instance_of(ApplicationController)
        .to receive(:user).and_return(
          {
            uid: 'foo',
            roles: %w[admin foo]
          }
        )

      source_a = Fabricate(
        :source,
        email_rank: 1,
        location_rank: 1,
        organization_name_rank: 1,
        organization_type_rank: 1,
        phone_number_rank: 1,
        website_rank: 1
      )

      source_b = Fabricate(
        :source,
        email_rank: 2,
        location_rank: 2,
        organization_name_rank: 2,
        organization_type_rank: 2,
        phone_number_rank: 2,
        website_rank: 2
      )

      visit "/sources/#{source_b.id}/edit"

      fill_in 'Name', with: 'New Name'

      first_option = "1 - insert above #{source_a.name}"

      select first_option, from: 'Email rank'
      select first_option, from: 'Location rank'
      select first_option, from: 'Organization name rank'
      select first_option, from: 'Organization type rank'
      select first_option, from: 'Phone number rank'
      select first_option, from: 'Website rank'

      click_button 'Update'

      expect(source_b.reload.name).to eq 'New Name'
      expect(source_b.email_rank).to eq 1
      expect(source_b.location_rank).to eq 1
      expect(source_b.organization_name_rank).to eq 1
      expect(source_b.organization_type_rank).to eq 1
      expect(source_b.phone_number_rank).to eq 1
      expect(source_b.website_rank).to eq 1
    end
  end
end
