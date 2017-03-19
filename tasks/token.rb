# frozen_string_literal: true
namespace :generate do
  desc 'Generate the needed tokens'
  task :token do
    require 'securerandom'
    File.write('.session_secret', SecureRandom.random_bytes(40))
    puts '<= generate:token executed'
  end
end
