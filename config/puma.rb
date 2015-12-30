#!/usr/bin/env puma

rails_env = :staging

environment rails_env

pidfile "/home/deploy/apps/rocketboard/#{rails_env}/shared/tmp/pids/puma.pid"
state_path "/home/deploy/apps/rocketboard/#{rails_env}/shared/tmp/sockets/puma.state"
stdout_redirect "/home/deploy/log/rocketboard/#{rails_env}-puma.access.log", "/home/deploy/log/rocketboard/#{rails_env}-puma.error.log"

rackup DefaultRackup

daemonize true

threads 4,4

activate_control_app "unix:///home/deploy/apps/rocketboard/#{rails_env}/shared/tmp/sockets/pumactl.sock", { auth_token: :poppinBottles }

ssl_bind "0.0.0.0", "9393", { key: "/home/deploy/apps/rocketboard/#{rails_env}/shared/ssl/nginx.key", cert: "/home/deploy/apps/rocketboard/#{rails_env}/shared/ssl/nginx.crt" }

preload_app!