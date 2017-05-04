class ImportMicroMachine < MicroMachine
  UNSTARTED = 'unstarted'.freeze
  PARSE = 'parse'.freeze
  PARSING = 'parsing'.freeze
  TRANSFORM = 'transform'.freeze
  TRANSFORMING = 'transforming'.freeze
  FINALIZE = 'finalize'.freeze
  FINALIZING = 'finalizing'.freeze
  FINISH = 'finish'.freeze
  FINISHED = 'finished'.freeze
  SYNC = 'sync'.freeze
  SYNCING = 'syncing'.freeze
  INSYNC = 'insync'.freeze
  SYNCED = 'synced'.freeze
  FAIL = 'fail'.freeze
  FAILED = 'failed'.freeze

  def self.completed_states
    [FINISHED, SYNCING, SYNCED, FAILED]
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

    self.when(PARSE, UNSTARTED => PARSING)
    self.when(TRANSFORM, PARSING => TRANSFORMING)
    self.when(FINALIZE, TRANSFORMING => FINALIZING)
    self.when(FINISH, FINALIZING => FINISHED)
    self.when(SYNC, FINISHED => SYNCING)
    self.when(INSYNC, SYNCING => SYNCED)
    self.when(FAIL, SYNCING => FAILED)
  end
end
