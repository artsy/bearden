desc 'Clear all Sidekiq queues'
task clear_sidekiq: :environment do
  queues = Sidekiq::Queue.all

  named_queues = [
    Sidekiq::ScheduledSet.new,
    Sidekiq::RetrySet.new,
    Sidekiq::DeadSet.new
  ]

  (queues + named_queues).each do |queue|
    puts queue
    puts queue.clear
  end
end
