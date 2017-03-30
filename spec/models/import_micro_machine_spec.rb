require 'rails_helper'

describe ImportMicroMachine do
  describe '.valid_states' do
    it 'returns the valid states' do
      valid_states = ImportMicroMachine.valid_states
      expect(valid_states).to eq %w(
        unstarted
        parsing
        transforming
        finalizing
        finished
        syncing
        synced
      )
    end
  end
end
