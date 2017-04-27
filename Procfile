web: bundle exec puma
worker_default: bundle exec sidekiq -c ${SIDEKIQ_CONCURRENCY} -q default
worker_debug: bundle exec sidekiq -c ${SIDEKIQ_CONCURRENCY} -q debug
