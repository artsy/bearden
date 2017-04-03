require 'rails_helper'

feature 'List Sources' do
  scenario 'Importer views list of sources' do
    Fabricate(
      :source,
      name: 'Source 1',
      email_rank: 1,
      location_rank: 2,
      organization_name_rank: 1,
      phone_number_rank: 1,
      website_rank: 3
    )

    Fabricate(
      :source,
      name: 'Source 2',
      email_rank: 3,
      location_rank: 1,
      organization_name_rank: 2,
      phone_number_rank: 2,
      website_rank: 1
    )

    Fabricate(
      :source,
      name: 'Source 3',
      email_rank: 2,
      location_rank: 3,
      organization_name_rank: 3,
      phone_number_rank: 3,
      website_rank: 2
    )

    visit '/sources'

    Source.all.each { |source| expect(page).to have_text source.name }

    (first_row, second_row, third_row) = page.all('tbody tr').to_a

    expect(first_row.all('td').map(&:text)).to eq(
      [
        '1',
        'Source 1',
        'Source 2',
        'Source 1',
        'Source 1',
        'Source 2'
      ]
    )

    expect(second_row.all('td').map(&:text)).to eq(
      [
        '2',
        'Source 3',
        'Source 1',
        'Source 2',
        'Source 2',
        'Source 3'
      ]
    )

    expect(third_row.all('td').map(&:text)).to eq(
      [
        '3',
        'Source 2',
        'Source 3',
        'Source 3',
        'Source 3',
        'Source 1'
      ]
    )
  end
end
