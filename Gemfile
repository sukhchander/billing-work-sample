source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.5'
gem 'pg', '~> 0.15'
#gem 'mysql2', '= 0.3.18'

gem 'haml-rails'
gem 'jquery-rails'

gem 'bootstrap-sass'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

#gem 'rails-api'
gem 'responders', '~> 2.0'
gem 'active_model_serializers'

gem 'kaminari'
gem 'simple_form'

gem 'devise', '= 3.5.2'
gem 'admin', path: './admin'

gem 'redis'
gem 'redis-rails'
gem 'redis-rack-cache'

gem 'mighty_tap'
gem 'active_attr'
gem 'paranoia', '~> 2.0'

gem 'fog'
gem 'aws-sdk'
#gem 'asset_sync'
gem 'sidekiq', '~> 4.0'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'rollbar', '~> 2.5.0'
gem 'configatron'
gem 'awesome_print'

gem 'gravtastic'

group :development do
  gem 'mina'
  gem 'mina-puma', require: false
  gem 'mina-extras', require: false
  gem 'mina-sidekiq', require: false
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'html2haml'
  gem 'hub', require: nil
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
  gem 'activerecord-colored_log_subscriber'
  gem 'sdoc', '~> 0.4.0', group: :doc
end

group :test do
  gem 'launchy'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'webmock', '~> 1.13.0'
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'factory_girl_rails', '~> 4.2.1'
end

group :development, :test do
  gem 'thin'
  gem 'steps'
  gem 'byebug'
  gem 'ffaker'
  gem 'progress_bar'
end

group :assets do
  gem 'breakpoint'
  gem 'therubyracer', platforms: :ruby
end

group :production do
  gem 'puma'
end