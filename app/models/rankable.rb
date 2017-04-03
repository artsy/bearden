module Rankable
  def rank_type
    self.class.name.underscore.concat('_rank').to_sym
  end

  def rank
    raw_input = versions.first&.actor
    return nil unless raw_input
    raw_input.import.source.rank_for rank_type
  end
end
