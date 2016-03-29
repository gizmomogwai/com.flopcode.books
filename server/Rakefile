# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'run test server with fresh db'
task :run_testserver do
  sh "rm -rf tmp"
  sh "RAILS_ENV=test rake db:drop db:schema:load db:seed"
  sh "RAILS_ENV=test rails s"
end
