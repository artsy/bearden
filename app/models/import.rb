class Import < ApplicationRecord
  mount_uploader :file_identifier, S3Uploader

  belongs_to :source
  has_many :raw_inputs

  validates :source, presence: true
  validates :state, presence: true, inclusion: ImportMicroMachine.valid_states

  def parse
    machine.trigger ImportMicroMachine::PARSE
    ParseCsvImportJob.perform_later id
  end

  def transform
    machine.trigger ImportMicroMachine::TRANSFORM
    RawInputTransformJob.perform_later id
  end

  def finalize
    machine.trigger ImportMicroMachine::FINALIZE
    FinalizeImportJob.perform_later id
  end

  def finish
    machine.trigger ImportMicroMachine::FINISH
  end

  def completed?
    ImportMicroMachine.completed_states.include? state
  end

  def sync
    machine.trigger ImportMicroMachine::SYNC
  end

  def insync
    machine.trigger ImportMicroMachine::INSYNC
  end

  def should_sync?
    raw_inputs.where.not(exception: nil).count != raw_inputs.count
  end

  def fail
    machine.trigger ImportMicroMachine::FAIL
  end

  private

  def machine
    @machine ||= ImportMicroMachine.start(state, method(:update_state))
  end

  def update_state(_)
    update_attributes state: machine.state
  end
end
