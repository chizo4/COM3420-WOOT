# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '3.1.2'

gem 'activerecord-session_store'
gem 'bootsnap', require: false
gem 'cancancan'
gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'devise'
gem 'draper'
gem 'epi_cas', git: 'git@git.shefcompsci.org.uk:gems/epi_cas.git'
gem 'hamlit'
gem 'hamlit-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'
gem 'redis', '~> 4.0'
gem 'sanitize_email'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'shakapacker'
gem 'simple_form'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'whenever'

# These gems might be considered in the future:
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem 'jbuilder'
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# Use Sass to process CSS
# gem 'sassc-rails'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'haml_lint', require: false
  gem 'rspec-rails'
  gem 'rubocop'
end

group :development do
  gem 'annotate'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'epi_deploy', git: 'https://github.com/epigenesys/epi_deploy.git'
  gem 'letter_opener'
  gem 'web-console'

  # These dev gems might be considered in the future:
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'webdrivers'
end
