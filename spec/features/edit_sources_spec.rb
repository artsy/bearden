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

    scenario 'the options do not include "Add to end"' do
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

      visit "/sources/#{source_a.id}/edit"

      expect(page).to_not have_content 'add to end'
    end

    scenario 'Admins can rank a source to last' do
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

      Fabricate(
        :source,
        email_rank: 2,
        location_rank: 2,
        organization_name_rank: 2,
        organization_type_rank: 2,
        phone_number_rank: 2,
        website_rank: 2
      )

      source_c = Fabricate(
        :source,
        email_rank: 3,
        location_rank: 3,
        organization_name_rank: 3,
        organization_type_rank: 3,
        phone_number_rank: 3,
        website_rank: 3
      )

      visit "/sources/#{source_a.id}/edit"

      fill_in 'source_name', with: 'New Name'

      last_option = "3: move here - #{source_c.name}"

      select last_option, from: 'Email rank'
      select last_option, from: 'Location rank'
      select last_option, from: 'Organization name rank'
      select last_option, from: 'Organization type rank'
      select last_option, from: 'Phone number rank'
      select last_option, from: 'Website rank'

      click_button 'Update'

      expect(source_a.reload.name).to eq 'New Name'
      expect(source_a.email_rank).to eq 3
      expect(source_a.location_rank).to eq 3
      expect(source_a.organization_name_rank).to eq 3
      expect(source_a.organization_type_rank).to eq 3
      expect(source_a.phone_number_rank).to eq 3
      expect(source_a.website_rank).to eq 3
    end
  end

  context 'with a non-admin' do
    let(:is_admin) { false }

    scenario 'Non-admins do not have access to create a new source' do
      Fabricate(:source)
      visit '/sources'
      expect(page).to_not have_css 'a.edit'
    end
  end
end
