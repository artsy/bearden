require 'rails_helper'

describe StartSyncJob do
  describe '#perform' do
    context 'with no imports to sync' do
      it 'marks the sync as skipped' do
        sync = Fabricate :sync, state: SyncMicroMachine::STARTING
        expect(SlackBot).to_not receive(:post)
        expect(OrganizationExportJob).to_not receive(:perform_later)
        StartSyncJob.new.perform sync.id
        expect(sync.reload.state).to eq SyncMicroMachine::SKIPPED
      end
    end

    context 'with an import to sync' do
      it 'posts to Slack, updates the sync and enqueues export jobs' do
        sync = Fabricate :sync, state: SyncMicroMachine::STARTING
        Fabricate :import, state: ImportMicroMachine::FINISHED
        Fabricate.times 3, :organization
        expect(SlackBot).to receive(:post)
        expect(OrganizationExportJob).to receive(:perform_later).with(sync.id, 1) # rubocop:disable Metric/LineLength
        expect(OrganizationExportJob).to receive(:perform_later).with(sync.id, 2) # rubocop:disable Metric/LineLength
        StartSyncJob.new.perform sync.id, 2
        expect(sync.reload.state).to eq SyncMicroMachine::EXPORTING
        expect(sync.total_parts).to eq 2
      end
    end
  end
end
