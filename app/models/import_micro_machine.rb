class ImportMicroMachine < MicroMachine
  UNSTARTED = 'unstarted'.freeze
  PARSE = 'parse'.freeze
  PARSING = 'parsing'.freeze
  TRANSFORM = 'transform'.freeze
  TRANSFORMING = 'transforming'.freeze
  FINISH = 'finish'.freeze
  FINISHED = 'finished'.freeze

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
    self.when(FINISH, TRANSFORMING => FINISHED)
  end
end
