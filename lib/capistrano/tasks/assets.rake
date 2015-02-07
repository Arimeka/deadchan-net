namespace :assets do
  desc 'Local assets compilation'
  task :precompile do
    run_locally do
      execute <<-CMD
        rake assets:clean
        nice -n 19 rake assets:precompile RAILS_ENV=#{fetch(:rails_env)}
        cd public
        tar -zcf assets.tar.gz assets
      CMD
    end
  end

  desc 'Upload assets'
  task :uploads do
    on roles(:app) do
      upload! "public/assets.tar.gz", "#{fetch(:release_path)}/public", via: :scp, recursive: true
      execute "cd #{fetch(:release_path)}/public && tar -xf assets.tar.gz && rm assets.tar.gz"
    end
    run_locally do
      execute "cd public && rm -rf assets*"
    end
  end
end
