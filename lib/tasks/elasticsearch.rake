namespace :elasticsearch do
  desc 'reindex all orgs in search'
  task :reindex do
    Organization.pluck(:id).each_slice(1000) do |ids|
      args = ids.map { |id| ['Organization', id] }
      Sidekiq::Client.push_bulk('class' => SearchIndexWorker, 'args' => args)
      puts "[#{Time.now}] Queued #{ids.size} ids."
    end
  end
end
