require 'rails_helper'

describe 'List Syncs' do
  scenario 'Importer views list of syncs' do
    skipped_sync = Fabricate(
      :sync,
      state: SyncMicroMachine::SKIPPED,
      created_at: 10.minutes.ago,
      updated_at: 10.minutes.ago
    )

    finished_sync = Fabricate(
      :sync,
      state: SyncMicroMachine::FINISHED,
      total_parts: 2,
      uploaded_parts: 2,
      created_at: 20.minutes.ago,
      updated_at: 5.minutes.ago
    )

    exporting_sync = Fabricate(
      :sync,
      state: SyncMicroMachine::EXPORTING,
      total_parts: 2,
      uploaded_parts: 1,
      created_at: 5.minutes.ago,
      updated_at: 2.minutes.ago
    )

    visit '/syncs'

    (first_row, second_row, third_row) = page.all('tbody tr').to_a

    expect(first_row.all('td').map(&:text)).to eq(
      [
        exporting_sync.id.to_s,
        SyncMicroMachine::EXPORTING,
        '1/2',
        '3 minutes',
        exporting_sync.created_at.to_s(:list_page)
      ]
    )

    expect(second_row.all('td').map(&:text)).to eq(
      [
        skipped_sync.id.to_s,
        SyncMicroMachine::SKIPPED,
        'n/a',
        'less than a minute',
        skipped_sync.created_at.to_s(:list_page)
      ]
    )

    expect(third_row.all('td').map(&:text)).to eq(
      [
        finished_sync.id.to_s,
        SyncMicroMachine::FINISHED,
        '2/2',
        '15 minutes',
        finished_sync.created_at.to_s(:list_page)
      ]
    )
  end
end
