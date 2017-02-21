PaperTrail.config.track_associations = false

module PaperTrail
  def self.with_actor(actor)
    current_actor = self.actor
    self.whodunnit = actor
    yield
    self.whodunnit = current_actor
  end
end
