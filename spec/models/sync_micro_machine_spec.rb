require 'rails_helper'

describe SyncMicroMachine do
  describe '.in_progress_states' do
    it 'returns valid states except finished' do
      in_progress_states = SyncMicroMachine.in_progress_states
      expect(in_progress_states).to eq %w(
        unstarted
        starting
        exporting
        copying
        finalizing
      )
    end
  end

  describe '.valid_states' do
    it 'returns the valid states' do
      valid_states = SyncMicroMachine.valid_states
      expect(valid_states).to eq %w(
        unstarted
        starting
        skipped
        exporting
        copying
        finalizing
        finished
      )
    end
  end
end
