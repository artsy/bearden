require 'rails_helper'

describe DataWarehouseSyncJob do
  context 'with a successful reset' do
    it 'reverts Imports and posts errors to Slack' do
      import = Fabricate :import, state: ImportMicroMachine::FINISHED
      result = double(:result, success?: false, errors: 'did not work')
      expect(DataWarehouseReset).to receive(:run).and_return(result)
      expect(SlackBot).to receive(:post).with 'sync starting'
      expect(SlackBot).to receive(:post).with 'sync failed with: did not work'
      DataWarehouseSyncJob.new.perform
      expect(import.reload.state).to eq ImportMicroMachine::FINISHED
    end
  end

  context 'with a failed reset' do
    it 'marks Imports and Synced and posts counts to Slack' do
      import = Fabricate :import, state: ImportMicroMachine::FINISHED
      result = double(:result, success?: true, before_count: 0, after_count: 1)
      expect(DataWarehouseReset).to receive(:run).and_return(result)
      expect(SlackBot).to receive(:post).with 'sync starting'
      expect(SlackBot).to receive(:post).with(
        'sync complete - before: 0, after: 1'
      )
      DataWarehouseSyncJob.new.perform
      expect(import.reload.state).to eq ImportMicroMachine::SYNCED
    end
  end
end
