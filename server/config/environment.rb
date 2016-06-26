# Load the Rails application.

require File.expand_path('../application', __FILE__)

REVISION_FILE = File.join(Rails.root, 'REVISION')
if File.exist?(REVISION_FILE)
  APP_VERSION = File.read(REVISION_FILE)[0...7]
else
  APP_VERSION = `git describe --always`.strip unless defined? APP_VERSION
end

# Initialize the Rails application.
Rails.application.initialize!
