# To make "deliver_later" work we need to tell ActiveJob to use Sidekiq. As long as Active Job is setup to use Sidekiq we can use "deliver_later".
# config.active_job.queue_adapter = :sidekiq