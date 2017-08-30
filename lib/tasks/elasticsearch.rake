namespace :elasticsearch do
  desc 'reindex all orgs in search'
  task reindex: :environment do
    Organization.pluck(:id).each_slice(1000) do |ids|
      args = ids.map { |id| ['Organization', id] }
      Sidekiq::Client.push_bulk('class' => SearchIndexJob, 'args' => args)
      puts "[#{Time.now.utc}] Queued #{ids.size} ids."
    end
  end
end
