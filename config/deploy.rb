after 'deploy', 'deploy:migrate'
set :application, '1net-discourse'

set :scm, :git
set :repo_url, 'git@github.com:neo/discourse.git'

set :stages, %w{staging production}
set :default_sage, "staging"

set :user, 'deployer'
set :use_sudo, false
set :deploy_via, :copy
set :keep_releases, 5
set :pty, true

set :rbenv_type, :user
set :rbenv_ruby, "2.0.0-p247"

set :default_env, { path: "/home/deployer/.rbenv/shims:/home/deployer/.rbenv/bin:$PATH" }

set :ssh_options, { forward_agent: true, port: 22 }

set :linked_files, %w{config/database.yml config/discourse.conf}
set :linked_dirs, %w{bin tmp/pids tmp/cache tmp/sockets log}


# Work around bug in capistrano.
# http://blog.blenderbox.com/2013/11/06/precompiling-assets-with-capistrano-3-0-1/
SSHKit.config.command_map[:rake] = "bundle exec rake"

after "deploy", "deploy:cleanup"
after "deploy", "deploy:restart"

namespace :deploy do
  # Tasks to start, stop and restart thin. This takes Discourse's
  # recommendation of changing the RUBY_GC_MALLOC_LIMIT.
  desc 'Start thin servers'
  task :start do
    on roles(:app) do
      execute "cd #{deploy_to}/current && PATH=/home/deployer/.rbenv/shims:/home/deployer/.rbenv/bin:$PATH RUBY_GC_MALLOC_LIMIT=90000000 bundle exec thin -C config/thin.yml start"
    end
  end

  desc 'Stop thin servers'
  task :stop do
    on roles(:app) do
      execute "cd #{deploy_to}/current && PATH=/home/deployer/.rbenv/shims:/home/deployer/.rbenv/bin:$PATH bundle exec thin -C config/thin.yml stop"
    end
  end

  desc 'Restart thin servers'
  task :restart do
    on roles(:app) do
      execute "cd #{deploy_to}/current && PATH=/home/deployer/.rbenv/shims:/home/deployer/.rbenv/bin:$PATH RUBY_GC_MALLOC_LIMIT=90000000 bundle exec thin -C config/thin.yml restart"
    end
  end
end

task :setup_shared_files => ["config/database.yml", "config/redis.yml", "config/discourse.conf", "config/mandrill.yml", "config/sidekiq.yml", "config/discourse.pill"]

remote_file "config/database.yml" => "config/database.yml.deploy", :roles => :app
remote_file "config/discourse.conf" => "config/discourse.conf.deploy", :roles => :app
remote_file "config/mandrill.yml" => "config/mandrill.yml.deploy", :roles => :app
remote_file "config/redis.yml" => "config/redis.yml.deploy", :roles => :app
remote_file "config/sidekiq.yml" => "config/sidekiq.yml.deploy", :roles => :app
remote_file "config/discourse.pill" => "config/discourse.pill.deploy", :roles => :app

after "deploy:check:make_linked_dirs", "setup_shared_files"
