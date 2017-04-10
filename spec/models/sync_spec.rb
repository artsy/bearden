require 'rails_helper'

describe Sync do
  describe '.in_progress?' do
    context 'with no syncs in progress' do
      it 'returns false' do
        Fabricate :sync, state: SyncMicroMachine::FINISHED
        expect(Sync.in_progress?).to eq false
      end
    end

    context 'with a sync in progress' do
      it 'returns true' do
        Fabricate :sync, state: SyncMicroMachine::UNSTARTED
        expect(Sync.in_progress?).to eq true
      end
    end
  end

  describe '#state' do
    context 'with an invalid state' do
      it 'is not valid' do
        sync = Fabricate :sync
        sync.state = 'invalid'
        expect(sync).to_not be_valid
        expect(sync.errors.messages).to eq(
          { state: ['is not included in the list'] }
        )
      end
    end

    context 'with a valid state' do
      it 'is valid' do
        sync = Fabricate :sync
        sync.state = SyncMicroMachine::FINISHED
        expect(sync).to be_valid
      end
    end
  end
end
