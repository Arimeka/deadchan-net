namespace :cache do
  desc 'Clear cache'
  task :clear do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: "#{fetch(:rails_env)}" do
          rake 'cache:clear'
        end
      end
    end
  end
end
