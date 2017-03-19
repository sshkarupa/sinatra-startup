# frozen_string_literal: true
require 'sinatra/base'

module MyApp
  class AssetsHandler < Sinatra::Base
    configure do
      set :root, File.expand_path(File.dirname(__FILE__) + '/../../')
      set :views { File.join(root + '/assets') }
      set :jsdir, 'js'
      set :cssdir, 'css'
      enable :coffeescript
      set :cssengine, 'sass'
      set :cssstyle, :compressed
    end

    get '/*.js' do
      pass unless settings.coffeescript?
      last_modified File.mtime(File.join(settings.views, settings.jsdir))
      cache_control :public, :must_revalidate
      coffee File.join(settings.jsdir, params[:splat].first).to_sym
    end

    get '/*.css' do
      last_modified File.mtime(File.join(settings.views, settings.cssdir))
      cache_control :public, :must_revalidate
      send(
        settings.cssengine,
        File.join(settings.cssdir, params[:splat].first).to_sym,
        style: settings.cssstyle
      )
    end
  end
end
