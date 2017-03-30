class Import < ApplicationRecord
  belongs_to :source
  has_many :raw_inputs

  validates :source, presence: true
  validates :uri, presence: true
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

  def finished?
    state == ImportMicroMachine::FINISHED
  end

  private

  def machine
    @machine ||= ImportMicroMachine.start(state, method(:update_state))
  end

  def update_state(_)
    update_attributes state: machine.state
  end
end
