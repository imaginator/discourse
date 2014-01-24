set :stage, :production
server '212.71.255.114', user: 'deployer', roles: %w{web app}
set :rails_env, 'production'
set :branch, "master"
