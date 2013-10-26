source 'https://rubygems.org'

gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'mongo_mapper'
gem 'decent_exposure'
gem 'russian'
gem 'haml'
gem 'bootstrap-sass', '~> 3.0.0.0.rc'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'capistrano'
  gem "rvm-capistrano"
  gem 'annotate', ">=2.5.0"  
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'letter_opener'
end

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem "rspec-rails", "~> 2.12"
  gem 'guard-rspec'
end

group :test do 
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'database_cleaner'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'libnotify'
end
