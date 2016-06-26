# Load the Rails application.

require File.expand_path('../application', __FILE__)

APP_VERSION = '0.0.1'#`git describe --always`.strip unless defined? APP_VERSION

# Initialize the Rails application.
Rails.application.initialize!
