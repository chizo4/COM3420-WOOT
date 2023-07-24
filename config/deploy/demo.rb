# frozen_string_literal: true

## Application deployment configuration
set :server,      'epi-stu-hut-demo4.shef.ac.uk'
set :user,        'demo.team22'
set :deploy_to,   -> { "/srv/services/#{fetch(:user)}" }
set :branch,      'demo'
set :application, fetch(:user)

## Server configuration
server fetch(:server), user: fetch(:user), roles: %w[web app db], ssh_options: { forward_agent: true }

## Additional tasks
namespace :deploy do
  task :seed do
    on primary :db do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end
