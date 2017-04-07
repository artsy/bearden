class SyncManagementJob < ApplicationJob
  def perform
    sync = Sync.where(state: SyncMicroMachine.in_progress_states).first

    if sync
      sync.copy if sync.ready_for_copy?
    else
      Sync.start
    end
  end
end
