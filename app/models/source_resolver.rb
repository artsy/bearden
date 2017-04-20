class SourceResolver
  def self.resolve(adjusted_source)
    new(adjusted_source).resolve
  end

  def initialize(adjusted_source)
    @adjusted_source = adjusted_source
  end

  def resolve
    return if @adjusted_source.save
    adjust_ranks
    @adjusted_source.save
  end

  private

  def conflicted_rank_types
    @adjusted_source.errors.keys
  end

  def adjust_ranks
    conflicted_rank_types.each do |rank_type|
      if demotion?(rank_type)
        move_sources_up(rank_type)
      else
        move_sources_down(rank_type)
      end
    end
  end

  def demotion?(rank_type)
    return false unless @adjusted_source.persisted?

    old, new = @adjusted_source.changes[rank_type]
    old < new
  end

  def move_sources_up(rank_type)
    sources_to_decrement(rank_type).each do |source|
      source.decrement!(rank_type)
    end
  end

  def sources_to_decrement(rank_type)
    cutoff = @adjusted_source.rank_for rank_type
    Source.where("#{rank_type} <= ?", cutoff).order(rank_type)
  end

  def move_sources_down(rank_type)
    sources_to_increment(rank_type).each do |source|
      source.increment!(rank_type)
    end
  end

  def sources_to_increment(rank_type)
    top_cutoff = @adjusted_source.rank_for rank_type
    old_rank = @adjusted_source.changes[rank_type].first
    default_bottom = Source.count + 1
    bottom_cutoff = old_rank || default_bottom
    query = "#{rank_type} >= ? AND #{rank_type} < ?"
    Source.where(query, top_cutoff, bottom_cutoff).order(rank_type => :desc)
  end
end
