# frozen_string_literal: true
require 'sequel'
require 'logger'

ENV['RACK_ENV'] ||= 'development'

# Delete DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  DATABASE_URL may contain passwords.
connection_uri = "postgres://vagrant:vagrant@127.0.0.1:5432/myapp_#{ENV['RACK_ENV']}"
DB = Sequel.connect(ENV.delete('DATABASE_URL') || connection_uri)

DB.loggers << Logger.new($stdout)

# DB.extension :pagination

# Sequel::Model.plugin :auto_validations
# Sequel::Model.plugin :prepared_statements
# Sequel::Model.plugin :prepared_statements_associations
# Sequel::Model.plugin :timestamps, update_on_create: true
