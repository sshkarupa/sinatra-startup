# frozen_string_literal: true
require 'spec_helper'
require 'myapp'

RSpec.describe MyApp do
  it 'has a version number' do
    expect(MyApp::VERSION).not_to be nil
  end
end
