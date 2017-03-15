PaperTrail.config.track_associations = false

module PaperTrail
  def self.track_changes_with(actor)
    original_actor = self.actor
    self.whodunnit = actor
    yield
    self.whodunnit = original_actor
  end

  def self.track_changes_with_transaction(actor)
    original_actor = self.actor
    self.whodunnit = actor
    Organization.transaction do
      yield
    end
    self.whodunnit = original_actor
  end
end
