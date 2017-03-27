class SourceResolver
  def self.resolve(new_source)
    new(new_source).resolve
  end

  def initialize(new_source)
    @new_source = new_source
  end

  def resolve
    return if @new_source.save
    adjust_ranks
    @new_source.save
  end

  private

  def adjust_ranks
    taken_rank_types.each do |rank_type|
      sources_to_adjust(rank_type).each do |source|
        source.increment!(rank_type)
      end
    end
  end

  def taken_rank_types
    @new_source.errors.keys
  end

  def sources_to_adjust(rank_type)
    cutoff = @new_source.rank_for rank_type
    Source.where("#{rank_type} >= ?", cutoff).order("#{rank_type} DESC")
  end
end
