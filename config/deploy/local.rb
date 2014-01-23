set :stage, :local
server '10.24.48.96', user: 'deployer', roles: %w{web app db}
set :rails_env, 'production'
set :branch, 'production'
