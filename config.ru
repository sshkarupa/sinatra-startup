# frozen_string_literal: true
# \ -p 9294 -o 0.0.0.0
lib = File.expand_path(File.dirname(__FILE__) + '/lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'myapp'
require 'myapp/db'
require 'myapp/web'

# Autoload controllers and models
Dir.glob("#{lib}/myapp/models/*.rb").each { |file| require file }
Dir.glob("#{lib}/myapp/controllers/*.rb").each { |file| require file }

ENV['SESSION_SECRET'] ||= File.read('.session_secret')
ENV['RACK_ENV'] ||= 'development'

# Check if all the migrations were executed
begin
  folder = File.expand_path(File.dirname(__FILE__) + '/db/migrate')
  Sequel.extension :migration
  Sequel::Migrator.check_current(DB, folder) unless Dir["#{folder}/*"].empty?
rescue Sequel::Migrator::NotCurrentError => e
  abort("\nError: #{e.message}")
end

use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']
use Rack::MethodOverride

{
  '/users' => MyApp::Users,
  # '/payments' => MyApp::Payments # just for example
}.each do |route, app|
  map route do
    run app
  end
end

# root routing
run MyApp::Web
