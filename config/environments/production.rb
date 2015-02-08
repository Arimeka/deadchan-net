DeadchanNet::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false

  # Compress JavaScripts and CSS.
  config.assets.compress = true
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :yui

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'
  config.assets.precompile += ['modernizr-2.6.2.min.js']

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  config.log_level = :info

  config.cache_store = :redis_store, {
    host: '127.0.0.1',
    port: 6379,
    db: 0,
    namespace: 'deadchan.net:cache',
    expires_in: 30*60
  }

  config.assets.expire_after 2.weeks
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
  config.logger = Logger.new(Rails.root.join("log",Rails.env + ".log"),10,100*1024*1024)
end
