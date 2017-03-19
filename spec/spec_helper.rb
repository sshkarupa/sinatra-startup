# frozen_string_literal: true
lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'myapp/db'
require 'rspec'
require 'rack/test'
require 'sequel'
require 'rspec_sequel_matchers'
require 'factory_girl'
require 'database_cleaner'
require 'pry'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include RspecSequel::Matchers
  config.include FactoryGirl::Syntax::Methods

  config.alias_example_to :fit, focus: true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.color = true
  config.default_formatter = 'Fuubar'
  config.default_formatter = :documentation if config.files_to_run.one?

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction

    FactoryGirl.find_definitions
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
