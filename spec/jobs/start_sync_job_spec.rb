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
        import = Fabricate :import, state: ImportMicroMachine::FINISHED
        Fabricate.times 3, :raw_input, import: import
        expect(SlackBot).to receive(:post)
        expect(OrganizationExportJob).to receive(:perform_later).with(sync.id, 1)
        StartSyncJob.new.perform sync.id
        expect(sync.reload.state).to eq SyncMicroMachine::EXPORTING
      end
    end

    context 'with an import that only has errors' do
      it 'does not trigger a sync' do
        sync = Fabricate :sync, state: SyncMicroMachine::STARTING
        import = Fabricate :import, state: ImportMicroMachine::FINISHED
        Fabricate :raw_input, import: import, exception: 'FooException'
        StartSyncJob.new.perform sync.id
        expect(sync.reload.state).to eq SyncMicroMachine::SKIPPED
      end
    end
  end
end
