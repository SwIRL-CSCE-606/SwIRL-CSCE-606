source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"
gem "sprockets-rails" # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "roo", "~> 2.10.1"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem 'aws-sdk-rails'

#Use password_digest 
#because Rails has a built-in method called has_secure_password which utilizes the bcrypt gem to handle password hashing. 
gem 'bcrypt', '~> 3.1.7'

group :production do
  gem 'pg' # for Heroku deployment
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "sqlite3", "~> 1.4"
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubycritic', require: false
  gem 'dotenv-rails'
  gem "rails-erd"
  gem 'factory_bot_rails'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem 'webdrivers'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov', require: false
end


