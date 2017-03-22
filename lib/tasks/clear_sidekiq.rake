desc 'Clear all Sidekiq queues'
task clear_sidekiq: :environment do
  sets = [
    Sidekiq::Queue,
    Sidekiq::ScheduledSet,
    Sidekiq::RetrySet,
    Sidekiq::DeadSet
  ]

  sets.each do |set|
    puts set
    puts set.new.clear
  end
end
