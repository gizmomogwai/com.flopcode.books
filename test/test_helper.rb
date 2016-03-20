require 'simplecov'
SimpleCov.start 'rails'

if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def login_as(user)
    if user
      session[:user] = {'user' => {'id' => users(user).id}}
    end
  end

end
