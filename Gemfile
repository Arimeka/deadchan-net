source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'jbuilder', '~> 1.2'
gem 'remotipart', '~> 1.2'
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'decent_exposure'
gem 'russian'
gem 'redis-rails'
gem 'devise'
gem 'will_paginate_mongoid'
gem 'redcarpet'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'rails-settings-cached', github: 'Arimeka/rails-settings-cached'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'aws-sdk'
gem 'paperclip-ffmpeg'

# HTML
gem 'haml'
gem 'haml-rails'
gem 'rails-settings-ui', '~> 0.3.0'

# Assets
gem 'bower-rails', '~> 0.9.1'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'rails-backbone', github: 'codebrew/backbone-rails', tag: 'v1.1.2'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'quiet_assets'
gem 'yui-compressor'
gem 'uglifier', '>= 1.3.0'

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
end
