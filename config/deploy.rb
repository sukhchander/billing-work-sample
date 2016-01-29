require "mina/bundler"
require "mina/rails"
require "mina/rbenv"
require "mina/puma"
require "mina/git"

set :term_mode, :system
set :forward_agent, true

set :user, "deploy"
set :repository, "git@github.com:sukhchander/rocketboard.git"

set :domain, "app.selastik.com"

set :shared_paths, [
  "log",
  "config/database.yml",
  "config/secrets.yml",
  "config/s3.yml",
  #"config/honeybadger.yml",
]

task :environment do
  invoke :"rbenv:load"

  stage = ENV["to"]
  case stage
    when "staging"
      set :branch, "develop"
    when "production"
      set :branch, "master"
    else
    print_error "Please specify a stage. eg: mina deploy to=production"
    exit
  end

  set :rails_env, stage
  set :stage, stage
  set :deploy_to, "/home/deploy/apps/rocketboard/#{stage}"
  set :app_path, lambda { "#{deploy_to}/#{current_path}" }
end

task setup: :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[touch "#{deploy_to}/shared/config/s3.yml"]
  queue! %[touch "#{deploy_to}/shared/config/puma.rb"]
  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  #queue! %[touch "#{deploy_to}/shared/config/honeybadger.yml"]
end

desc "Deploy current version to the server."
task deploy: :environment do

  #set :sidekiq_config, lambda { "#{deploy_to}/#{shared_path}/config/sidekiq.yml" }
  #set :sidekiq_log, lambda { "#{deploy_to}/#{shared_path}/log/sidekiq.log" }
  #set :sidekiq_pid, lambda { "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid" }

  deploy do
    invoke :"git:clone"
    invoke :"deploy:link_shared_paths"
    invoke :"bundle:install"
    invoke :"rails:db_migrate"
    invoke :"rails:assets_precompile"
    #invoke :'sidekiq:restart'

    to :launch do
      queue "echo 'PUMA - RESTARTING'"
      invoke :"puma:restart"
      queue "echo 'PUMA - RESTARTED'"
    end
  end
end

task :errorlog do
  queue "tail -f /var/log/nginx/error.log"
end

task :accesslog do
  queue "tail -f /var/log/nginx/access.log"
end