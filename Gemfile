# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'sinatra'
gem 'sinatra-flash'
gem 'sinatra-redirect-with-flash'
gem 'sass'
gem 'slim'
gem 'coffee-script', '~> 2.4', '>= 2.4.1'
gem 'mini_racer', '~> 0.1.8'
gem 'sequel'
gem 'pg'
gem 'rake'

group :test, :development do
  gem 'pry-byebug', '~> 3.4'
  gem 'racksh', '~> 1.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'fuubar', '~> 2.0'
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec_sequel_matchers', '~> 0.4.0'
  gem 'simplecov', '~> 0.13.0'
  gem 'timecop'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'thin'
end

group :production do
  gem 'puma'
end
