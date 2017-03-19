# frozen_string_literal: true
lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

task :app do
  require 'myapp/db'
end

namespace :db do
  desc 'Prints current schema version'
  task version: :app do
    Sequel.extension :migration
    version = if DB.tables.include?(:schema_info)
                DB[:schema_info].first[:version]
              end || 0
    puts "<= schema version: #{version}"
  end

  desc 'Create a db/schema.rb'
  task dump: :app do
    DB.extension :schema_dumper
    filename = ENV['SCHEMA'] || 'db/schema.rb'
    schema = DB.dump_schema_migration
    File.open(filename, 'w') { |f| f.write(schema) }
  end

  namespace :migrate do
    desc 'Perform migration up to latest migration available'
    task up: :app do
      Sequel.extension(:migration)
      Sequel::Migrator.run(Sequel::Model.db, 'db/migrate')
      puts '<= db:migrate:up executed'
      Rake::Task['db:version'].execute
      Rake::Task['db:dump'].execute
    end

    desc 'Perform migration down (erase all data)'
    task down: :app do
      Sequel.extension(:migration)
      Sequel::Migrator.run(Sequel::Model.db, 'db/migrate', target: 0)
      puts '<= db:migrate:down executed'
      Rake::Task['db:version'].execute
      Rake::Task['db:dump'].execute
    end
  end

  desc 'Perform migration up to latest migration available'
  task migrate: 'db:migrate:up'

  desc 'Create the database'
  task create: :app do
    config = Sequel::Model.db.opts
    config[:charset] = 'utf8' unless config[:charset]
    puts "=> Creating database '#{config[:database]}'"
    create_db(config)
    puts '<= db:create executed'
  end

  desc 'Drop the database'
  task drop: :app do
    Sequel::Model.db.disconnect
    config = Sequel::Model.db.opts
    puts "=> Dropping database '#{config[:database]}'"
    drop_db(config)
    puts '<= db:drop executed'
  end
end

def self.create_db(config)
  environment = {}
  environment['PGUSER']     = config[:user]
  environment['PGPASSWORD'] = config[:password]
  arguments = []
  arguments << "--encoding=#{config[:charset]}" if config[:charset]
  arguments << "--host=#{config[:host]}" if config[:host]
  arguments << "--username=#{config[:user]}" if config[:user]
  arguments << config[:database]
  Process.wait Process.spawn(environment, 'createdb', *arguments)
end

def self.drop_db(config)
  environment = {}
  environment['PGUSER']     = config[:user]
  environment['PGPASSWORD'] = config[:password]
  arguments = []
  arguments << "--host=#{config[:host]}" if config[:host]
  arguments << "--username=#{config[:user]}" if config[:user]
  arguments << config[:database]
  Process.wait Process.spawn(environment, 'dropdb', *arguments)
end
