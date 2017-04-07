class SyncMicroMachine < MicroMachine
  UNSTARTED = 'unstarted'.freeze
  START = 'start'.freeze
  STARTING = 'starting'.freeze
  EXPORT = 'export'.freeze
  EXPORTING = 'exporting'.freeze
  COPY = 'copy'.freeze
  COPYING = 'copying'.freeze
  FINALIZE = 'finalize'.freeze
  FINALIZING = 'finalizing'.freeze
  FINISH = 'finish'.freeze
  FINISHED = 'finished'.freeze

  def self.in_progress_states
    valid_states - [FINISHED]
  end

  def self.valid_states
    machine = new(UNSTARTED)
    machine.configure
    machine.states
  end

  def self.start(initial_state, callback)
    new(initial_state).tap { |machine| machine.configure(callback) }
  end

  def configure(callback = nil)
    on(:any, &callback) if callback

    self.when(START, UNSTARTED => STARTING)
    self.when(EXPORT, STARTING => EXPORTING)
    self.when(COPY, EXPORTING => COPYING)
    self.when(FINALIZE, COPYING => FINALIZING)
    self.when(FINISH, FINALIZING => FINISHED)
  end
end
