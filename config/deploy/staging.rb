set :stage, :production
server '176.58.98.19', user: 'deployer', roles: %w{web app}
set :rails_env, 'production'
set :branch, "master"
