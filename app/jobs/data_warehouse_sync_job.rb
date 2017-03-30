class DataWarehouseSyncJob < ApplicationJob
  def perform
    SlackBot.post('sync starting')
    update_finished_imports

    result = DataWarehouseReset.run
    update_syncing_imports(result.success?)

    result_message = message_for(result)
    SlackBot.post(result_message)
  end

  private

  def update_finished_imports
    Import.where(state: ImportMicroMachine::FINISHED).each(&:sync)
  end

  def update_syncing_imports(success)
    outcome = success ? :insync : :revert
    Import.where(state: ImportMicroMachine::SYNCING).each(&outcome)
  end

  def message_for(result)
    if result.success?
      before = result.before_count
      after = result.after_count

      "sync complete - before: #{before}, after: #{after}"
    else
      "sync failed with: #{result.errors}"
    end
  end
end
