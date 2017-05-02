class FinishSyncJob < ApplicationJob
  attr_accessor :sync

  queue_as :default

  def perform(sync_id)
    @sync = Sync.find_by id: sync_id
    return unless sync

    result = DataWarehouse.reset(sources)

    sync.finalize
    update_syncing_imports(result.success?)

    result_message = message_for(result)
    SlackBot.post(result_message)

    sync.finish
  end

  private

  def sources
    (1..sync.total_parts).map do |part|
      bucket_name = Rails.application.secrets.aws_bucket
      key = "#{sync.export_folder}/#{part}.csv"
      "s3://#{bucket_name}/#{key}"
    end
  end

  def update_syncing_imports(success)
    outcome = success ? :insync : :revert
    Import.where(state: ImportMicroMachine::SYNCING).each(&outcome)
  end

  def message_for(result)
    if result.success?
      before = result.before_count
      after = result.after_count

      ":dancers: Sync complete - before: #{before}, after: #{after}"
    else
      ":face-palm: Sync failed with: #{result.errors}"
    end
  end
end
