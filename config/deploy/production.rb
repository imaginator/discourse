set :stage, :production
server '212.71.255.114', user: 'deployer', roles: %w{web app db}
set :rails_env, 'production'
set :branch, "production"
set :deploy_to, "/home/deployer/1net-forum"
