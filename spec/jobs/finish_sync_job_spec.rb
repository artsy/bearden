require 'rails_helper'

describe FinishSyncJob do
  describe '#perform' do
    context 'with successful reset' do
      it 'resets the data warehouse, updates the imports, posts to Slack and updates the Sync' do
        sources = ['s3://testing/folder/timestamp/1.csv']
        result = double(
          :result,
          success?: true,
          before_count: 0,
          after_count: 1
        )
        expect(DataWarehouse).to receive(:reset)
          .with(sources).and_return(result)
        success_message = ':dancers: Sync complete - before: 0, after: 1'
        expect(SlackBot).to receive(:post).with(success_message)
        sync = Fabricate :sync, total_parts: 1
        expect_any_instance_of(Sync).to receive(:export_folder)
          .and_return('folder/timestamp')
        import = Fabricate :import, state: ImportMicroMachine::SYNCING
        FinishSyncJob.new.perform(sync.id)
        expect(import.reload.state).to eq ImportMicroMachine::SYNCED
      end
    end

    context 'with errors' do
      it 'reverts the imports and posts those errors to Slack' do
        result = double(:result, success?: false, errors: 'bogus')
        allow(DataWarehouse).to receive(:reset).and_return(result)
        message = ':face-palm: Sync failed with: bogus'
        expect(SlackBot).to receive(:post).with(message)
        sync = Fabricate :sync, total_parts: 1
        import = Fabricate :import, state: ImportMicroMachine::SYNCING
        FinishSyncJob.new.perform(sync.id)
        expect(import.reload.state).to eq ImportMicroMachine::FAILED
      end
    end
  end
end
