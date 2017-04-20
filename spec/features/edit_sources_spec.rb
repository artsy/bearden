require 'rails_helper'

feature 'Edit Source' do
  scenario 'Importer edits source' do
    source_a = Fabricate(
      :source,
      email_rank: 1,
      location_rank: 1,
      organization_name_rank: 1,
      phone_number_rank: 1,
      website_rank: 1
    )

    source_b = Fabricate(
      :source,
      email_rank: 2,
      location_rank: 2,
      organization_name_rank: 2,
      phone_number_rank: 2,
      website_rank: 2
    )

    visit "/sources/#{source_b.id}/edit"

    fill_in 'Name', with: 'New Name'

    first_option = "1 - insert above #{source_a.name}"

    select first_option, from: 'Email rank'
    select first_option, from: 'Location rank'
    select first_option, from: 'Organization name rank'
    select first_option, from: 'Phone number rank'
    select first_option, from: 'Website rank'

    click_button 'Update'

    expect(source_b.reload.name).to eq 'New Name'
    expect(source_b.email_rank).to eq 1
    expect(source_b.location_rank).to eq 1
    expect(source_b.organization_name_rank).to eq 1
    expect(source_b.phone_number_rank).to eq 1
    expect(source_b.website_rank).to eq 1
  end
end
