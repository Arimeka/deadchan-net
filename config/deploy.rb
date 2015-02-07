# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'deadchan-net'
set :repo_url, 'git@github.com:Arimeka/deadchan-net.git'
set :git_shallow_clone, 1
set :scm_verbose, true
set :default_stage, 'staging'
set :ssh_options, {
  user: 'deadchan',
  forward_agent: true,
  keys: %w(~/.ssh/id_rsa)
}
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.5'

if ENV['BRANCH']
  set :branch, ENV['BRANCH']
else
  ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
end

set :linked_dirs, %w{log tmp/pids tmp/cache vendor/bundle}
set :linked_files, %w{config/s3.yml config/recaptcha.yml}

namespace :deploy do
  # Assets
  before  'deploy',          'deploy:check'
  before  'deploy',          'assets:precompile'
  after   'deploy:updated',  'assets:uploads'
  after   'deploy:cleanup',  'deploy:restart'
  after   'deploy:rollback', 'deploy:restart'
  after   'deploy',          'cache:clear'

  desc 'Unicorn restart'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end

  desc 'Unicorn start'
  task :start do
    on roles(:app) do
      invoke 'unicorn:start'
    end
  end

  desc 'Unicorn stop'
  task :stop do
    on roles(:app) do
      invoke 'unicorn:stop'
    end
  end
end
