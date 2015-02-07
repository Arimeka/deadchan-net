sidekiq_env = ENV.fetch('SIDEKIQ_NS', 'deadchan-net')

Sidekiq.configure_server do |config|
  config.redis = { namespace: sidekiq_env, size: 25 }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: sidekiq_env, size: 5 }
end
