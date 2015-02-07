# -*- coding: utf-8 -*-
#############################################################
# Signal handling (master worker)
#############################################################
# HUP - reloads config file and gracefully restart all workers.
# If the “preload_app” directive is false (the default), then
# workers will also pick up any application code changes when
# restarted. If “preload_app” is true, then application code
# changes will have no effect; USR2 + QUIT (see below) must be
# used to load newer code in this case. When reloading the
# application, Gem.refresh will be called so updated code for
# your application can pick up newly installed RubyGems. It is
# not recommended that you uninstall libraries your application
# depends on while Unicorn is running, as respawned workers may
# enter a spawn loop when they fail to load an uninstalled
# dependency.
# INT/TERM - quick shutdown, kills all workers immediately
# QUIT - graceful shutdown, waits for workers to finish their
# current request before finishing.
# USR1 - reopen all logs owned by the master and all workers See
# Unicorn::Util.reopen_logs for what is considered a log.
# USR2 - reexecute the running binary. A separate QUIT should be
# sent to the original process once the child is verified to be
# up and running.
# WINCH - gracefully stops workers but keep the master running.
# This will only work for daemonized processes.
# TTIN - increment the number of worker processes by one
# TTOU - decrement the number of worker processes by one
#############################################################

deploy_to  = '/var/www/staging.deadchan.net'
rails_root = "#{deploy_to}/current"
pid_file   = "#{deploy_to}/shared/tmp/pids/unicorn.pid"
socket_file= "#{deploy_to}/shared/tmp/sockets/unicorn.sock"
log_file   = "#{rails_root}/log/unicorn.log"
err_log    = "#{rails_root}/log/unicorn_error.log"
old_pid    = pid_file + '.oldbin'

timeout 60
worker_processes 4
listen socket_file, backlog: 1024
pid pid_file
stderr_path err_log
stdout_path log_file

preload_app true

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH

    end
  end
end

after_fork do |server, worker|
  Redis.current.quit
  Rails.cache.reconnect
end
