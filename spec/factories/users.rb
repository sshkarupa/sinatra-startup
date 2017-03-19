# frozen_string_literal: true
require 'myapp/models/user'

FactoryGirl.define do
  to_create(&:save)

  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user, class: MyApp::User do
    # add your factory code for user model here
    #
    # name 'John'
    # email
  end
end
