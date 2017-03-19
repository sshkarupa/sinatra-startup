# frozen_string_literal: true
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  raise e
end

task default: :spec
