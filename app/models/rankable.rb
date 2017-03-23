module Rankable
  def rank
    raw_input = versions.first&.actor
    return nil unless raw_input
    raw_input.import.source.rank_for self
  end
end
