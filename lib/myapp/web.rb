# frozen_string_literal: true
require 'myapp/controllers/application'

module MyApp
  class Web < Application
    get '/' do
      raise 'Oops! See you at the better_errors error page!'
    end
  end
end
