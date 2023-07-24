# frozen_string_literal: true

if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter 'app/jobs'
    add_filter 'app/mailers'
    add_filter 'app/decorators'
    add_filter 'app/controllers/pages_controller.rb'
    add_filter 'app/models/ability.rb'
  end
end
