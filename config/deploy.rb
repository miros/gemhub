set :application, "gemhub"
set :repository, "git@github.com:miros/gemhub.git"

set :scm, :git
set :domain, 'mirosm.ru'

role :web, domain
role :app, domain
role :db,  domain, :primary => true

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

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
