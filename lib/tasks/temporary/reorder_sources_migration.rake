namespace :temporary do
  desc 'For each rank, reorder the sources'
  task reorder_sources_migration: :environment do
    source_ranks = Source.column_names.keep_if {|name| name.end_with?('_rank') }

    source_ranks.each do |rank_name|
      counter = 0
      rank_column_name = rank_name.to_sym
      sources = Source.pluck(rank_column_name, :id, :name).sort

      sources.each do |source|
        Source.find(source[1]).update_attribute(rank_column_name, counter += 1)
      end
    end
  end
end
