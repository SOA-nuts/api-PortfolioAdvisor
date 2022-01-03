# frozen_string_literal: true

# require_relative '../app/domain/init'
# require_relative '../app/application/requests/init'
# require_relative '../app/infrastructure/google_news/init'
# require_relative '../app/infrastructure/crawler/init'
# require_relative '../app/presentation/representers/init'
# require_relative '../app/infrastructure/database/init'
require_relative '../init'
require_relative 'add_news_monitor'
require_relative 'job_reporter'

require 'figaro'
require 'shoryuken'

# Shoryuken worker class to clone repos in parallel
module NewsAdd
  class Worker
    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment: ENV['RACK_ENV'] || 'development',
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config() = Figaro.env

    Shoryuken.sqs_client = Aws::SQS::Client.new(
      access_key_id: config.AWS_ACCESS_KEY_ID,
      secret_access_key: config.AWS_SECRET_ACCESS_KEY,
      region: config.AWS_REGION
    )

    include Shoryuken::Worker
    Shoryuken.sqs_client_receive_message_opts = { wait_time_seconds: 20 }
    shoryuken_options queue: config.CLONE_QUEUE_URL, auto_delete: true

    def perform(_sqs_msg, request)
      job = JobReporter.new(request, Worker.config)

      job.report(AddMonitor.starting_percent)
      if(job.need_update)
        update_target = PortfolioAdvisor::GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(job.company_name, job.symbol)
        PortfolioAdvisor::Repository::For.entity(update_target).update(update_target)
      else
        #create new one
        new_target = PortfolioAdvisor::GoogleNews::TargetMapper.new(Worker.config.GOOGLENEWS_TOKEN).find(job.company_name, job.symbol)
        PortfolioAdvisor::Repository::For.entity(new_target).create(new_target)
      end

      # Keep sending finished status to any latecoming subscribers
      job.report_each_second(5) { AddMonitor.finished_percent }
    rescue StandardError => e
      # worker should crash fail early - only catch errors we expect!
      puts e.inspect
      puts e.backtrace.join("\n")
      puts 'TARGET EXISTS -- ignoring request'
    end
  end
end
