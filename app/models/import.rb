class Import < ApplicationRecord
  belongs_to :source
  has_many :raw_inputs

  validates :source, presence: true
  validates :uri, presence: true
  validates :state, presence: true, inclusion: ImportMicroMachine.valid_states

  def parse
    machine.trigger ImportMicroMachine::PARSE
  end

  def transform
    machine.trigger ImportMicroMachine::TRANSFORM
  end

  def finish
    machine.trigger ImportMicroMachine::FINISH
  end

  private

  def machine
    @machine ||= ImportMicroMachine.start(state, method(:update_state))
  end

  def update_state(_)
    update_attributes state: machine.state
  end
end
