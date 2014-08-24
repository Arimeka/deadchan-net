source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'rails-backbone', github: 'codebrew/backbone-rails', tag: 'v1.1.2'
gem 'remotipart', '~> 1.2'
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'decent_exposure'
gem 'russian'
gem 'haml'
gem "haml-rails"
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'bootstrap_notify', git: 'git@git.nnbs.ru:gem/bootstrap_notify.git', tag: 'v0.0.2'
gem 'bootstrap-wysihtml5-rails'
gem 'redis-rails'
gem 'yui-compressor'
gem 'devise'
gem 'tire'
gem 'will_paginate_mongoid'
gem 'redcarpet'
gem 'quiet_assets'
gem 'recaptcha', require: 'recaptcha/rails'

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
  gem 'spring'
end

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem "rspec-rails", "~> 2.12"
  gem 'guard-rspec'
  gem "letter_opener"
  gem "ffaker"
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'simplecov', :require => false
  gem 'database_cleaner'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'libnotify'
end
