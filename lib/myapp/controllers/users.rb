# frozen_string_literal: true
require 'supsys/controllers/application'

module Supsys
  class Users < Application
    get '/' do
      slim :'users/index', locals: { title: 'Users' }
    end
  end
end
