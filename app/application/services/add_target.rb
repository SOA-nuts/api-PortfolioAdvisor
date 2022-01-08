# frozen_string_literal: true

require 'dry/transaction'

COMPANY_YAML = 'spec/fixtures/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  module Service
    # Transaction to store target from NEWS API to database
    class AddTarget
      include Dry::Transaction

      step :identify_target
      step :find_target
      #step :store_target

      private

      INVALID_MSG = "Invalid company name"
      DB_ERR_MSG = 'Having trouble accessing the database'
      NOT_SUPPORT_MSG = 'this company is not on our supporting list'
      GN_NOT_FOUND_MSG = 'Could not find related articles of the company on Google News'

      def identify_target(input)
        if COMPANY_LIST[0][input[:company_name].downcase].nil? 
          Failure(Response::ApiResult.new(status: :internal_error, message: INVALID_MSG))
        else
          Success(input)
        end
      end

      def find_target(input)
        target = target_in_database(input)

        input[:symbol] = COMPANY_LIST[0][input[:company_name]]

        Messaging::Queue.new(App.config.ADD_QUEUE_URL, App.config)
          .send(add_target_request_json(input))

        Success(Response::ApiResult.new(status: :created, message: target))
      rescue StandardError => error
        print_error(error)
        Failure(Response::ApiResult.new(status: :not_support, message: error.to_s))
      end

      # def store_target(input)
      #   target =
      #     if (new_target = input[:remote_target])
      #       Repository::For.entity(new_target).create(new_target)
      #     elsif (update_target = input[:update_target])
      #       Repository::For.entity(update_target).update(update_target)
      #     else
      #       input[:local_target]
      #     end
      #   Success(Response::ApiResult.new(status: :created, message: target))
      # rescue StandardError => e
      #   puts "#{e.inspect}\\n#{e.backtrace}"
      #   Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      # end

      # following are support methods that other services could use
      def target_in_database(input)
        Repository::Targets.find_company(input[:company_name])
      end

      # def target_update_from_news(input)
      #   symbol = COMPANY_LIST[0][input[:company_name]]
      #   GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(input[:company_name], symbol)
      # rescue StandardError
      #   raise GN_NOT_FOUND_MSG
      # end

      # def target_from_news(input)
      #   symbol = COMPANY_LIST[0][input[:company_name]]
      #   if symbol.nil?
      #     Failure(Response::ApiResult.new(status: :not_found, message: GN_NOT_FOUND_MSG))
      #   else
      #     GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(input[:company_name], symbol)
      #   end
      # rescue StandardError => e
      #   raise GN_NOT_FOUND_MSG
      # end

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end

      def add_target_request_json(input)
        Response::SearchRequest.new(input[:company_name], input[:request_id])
          .then { Representer::SearchRequest.new(_1) }
          .then(&:to_json)
      end
    end
  end
end
