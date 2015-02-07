namespace :cache do
  desc 'Cache clear'
  task clear: :environment do
    Rails.cache.clear
  end
end
