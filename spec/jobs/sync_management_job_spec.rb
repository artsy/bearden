require 'rails_helper'

describe SyncManagementJob do
  describe '#perform' do
    context 'with no Syncs' do
      it 'starts a Sync' do
        allow(StartSyncJob).to receive(:perform_later)
        SyncManagementJob.new.perform
        expect(Sync.count).to eq 1
      end
    end

    context 'with a Sync in progress' do
      it 'does nothing' do
        Fabricate :sync, state: SyncMicroMachine::STARTING
        SyncManagementJob.new.perform
        expect(Sync.count).to eq 1
        expect(Sync.first.state).to eq SyncMicroMachine::STARTING
      end
    end

    context 'with a Sync that is exporting' do
      context 'but not all parts have been exported' do
        it 'does nothing' do
          Fabricate(
            :sync,
            state: SyncMicroMachine::EXPORTING,
            total_parts: 2,
            uploaded_parts: 1
          )
          SyncManagementJob.new.perform
          expect(Sync.count).to eq 1
          expect(Sync.first.state).to eq SyncMicroMachine::EXPORTING
        end
      end

      context 'and all parts have been exported' do
        it 'moves that Sync to copying' do
          allow(FinishSyncJob).to receive(:perform_later)
          Fabricate(
            :sync,
            state: SyncMicroMachine::EXPORTING,
            total_parts: 2,
            uploaded_parts: 2
          )
          SyncManagementJob.new.perform
          expect(Sync.count).to eq 1
          expect(Sync.first.state).to eq SyncMicroMachine::COPYING
        end
      end
    end

    context 'with a Sync that has finished' do
      it 'starts another Sync' do
        Fabricate :sync, state: SyncMicroMachine::FINISHED
        SyncManagementJob.new.perform
        expect(Sync.count).to eq 2
      end
    end
  end
end
