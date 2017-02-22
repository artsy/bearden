PaperTrail.config.track_associations = false

module PaperTrail
  def self.with_actor(actor)
    original_actor = self.actor
    self.whodunnit = actor
    yield
    self.whodunnit = original_actor
  end
end
