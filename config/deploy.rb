set :user, "ec2-user"
set :group, "apache"
set :application, "pyropus"
set :repository,  "ssh://pyrop.us/home/ec2-user/pyropus.git"
set :deploy_to,   "/var/www/pyropus"
set :use_sudo, false

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "pyrop.us"                          # Your HTTP server, Apache/etc
role :app, "pyrop.us"                          # This may be the same as your `Web` server
role :db,  "pyrop.us", :primary => true # This is where Rails migrations will run

set :rails_env, :production

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  task :submodule do
    run "cd #{current_path}; git submodule sync ; git submodule update"
  end
end

after "deploy:update_code", :bundle_install
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end
# role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
