# frozen_string_literal: true
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sass'
require 'slim'
require 'mini_racer'
require 'coffee-script'
require 'myapp/assets_handler'

module MyApp
  class Application < Sinatra::Base
    set :root, File.expand_path(File.dirname(__FILE__) + '/../../../')
    register Sinatra::Flash

    use MyApp::AssetsHandler

    configure :production do
      disable :show_exceptions
    end

    configure :development do
      require 'pry'
      require 'better_errors'

      set :show_exceptions, :after_handler
      enable :reloader

      use BetterErrors::Middleware
      BetterErrors.application_root = settings.root
      BetterErrors::Middleware.allow_ip! '0.0.0.0/0'
    end

    configure :production, :development do
      enable :logging
    end
  end
end
