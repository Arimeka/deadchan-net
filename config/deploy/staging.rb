set :deploy_to, '/var/www/staging.deadchan.net'
set :unicorn_config_path, "#{fetch(:deploy_to)}/current/config/unicorn/staging.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/tmp/pids/unicorn.pid"
set :rails_env, 'staging'

role :app, %w{staging.deadchan.net}
role :db,  %w{staging.deadchan.net}, primary: true
