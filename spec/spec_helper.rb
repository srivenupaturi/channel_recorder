# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

def create_user
  User.create!('email' => 'test@channel_recorder.com', 'fname' => 'Abc', 'lname' => 'Xyz')
end

# comparing time stamps
RSpec::Matchers.define :be_same_time_as do |expected|
  match do |actual|
    expected.to_i == actual.to_i
  end
end
