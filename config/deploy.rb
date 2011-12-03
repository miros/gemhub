set :application, "gemhub"
set :repository, "git@github.com:miros/gemhub.git"

set :scm, :git
set :domain, 'mirosm.ru'

role :web, domain
role :app, domain
role :db,  domain, :primary => true
set :rails_env, "development"

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache

set :user, "deploy"
set :use_sudo, false

set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
}

set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

#ssh_options[:compression] = false
default_run_options[:pty] = true

set :unicorn_binary, "#{current_path}/bin/unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`" if remote_file_exists?(unicorn_pid)
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`" if remote_file_exists?(unicorn_pid)
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`" if remote_file_exists?(unicorn_pid)
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

