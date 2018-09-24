require_relative 'config/application'
require 'resque/tasks'
require 'resque/scheduler/tasks'

Rails.application.load_tasks


namespace :resque do
  task :setup_schedule do
    require 'resque-scheduler'

    Resque::Scheduler.dynamic = true
  end

  task :scheduler => :setup_schedule
  task :setup => :environment do
    require 'resque'

    Resque.redis = Redis.new(url: ENV['REDIS_URL'], thread_safe: true)
  end
end
