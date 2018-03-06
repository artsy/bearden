class Sync < ApplicationRecord
  validates :state, presence: true, inclusion: SyncMicroMachine.valid_states

  def self.in_progress?
    where(state: SyncMicroMachine.in_progress_states).any?
  end

  def self.start
    new(state: SyncMicroMachine::UNSTARTED).start
  end

  def start
    machine.trigger SyncMicroMachine::START
    StartSyncJob.perform_later id
  end

  def skip
    machine.trigger SyncMicroMachine::SKIP
  end

  def export
    machine.trigger SyncMicroMachine::EXPORT
  end

  def copy
    machine.trigger SyncMicroMachine::COPY
    FinishSyncJob.perform_later id
  end

  def finalize
    machine.trigger SyncMicroMachine::FINALIZE
  end

  def finish
    machine.trigger SyncMicroMachine::FINISH
  end

  def increment_uploaded_parts
    increment! :uploaded_parts # rubocop:disable Rails/SkipsModelValidations
  end

  def export_folder
    timestamp = created_at.to_s(:export_folder)
    "data_warehouse_reset/#{timestamp}"
  end

  def ready_for_copy?
    state == SyncMicroMachine::EXPORTING && total_parts == uploaded_parts
  end

  private

  def machine
    @machine ||= SyncMicroMachine.start(state, method(:update_state))
  end

  def update_state(_, _)
    update state: machine.state
  end
end
