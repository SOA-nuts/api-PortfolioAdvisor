# frozen_string_literal: true

require 'dry/transaction'

COMPANY_YAML = 'spec/fixtures/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  module Service
    # Transaction to store target from NEWS API to database
    class AddTarget
      include Dry::Transaction

      step :find_target
      step :return_target

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      NOT_SUPPORT_MSG = 'this company is not on our supporting list'
      GN_NOT_FOUND_MSG = 'Could not find related articles of the company on Google News'
      PROCESSING_MSG = 'Adding the project'

      def find_target(input)
        if (target = target_in_database(input))
          # no need update
          Success(input)
          if(target.updated_at == Date.today)
            #need update
            input[:need_update] = true
          end
        else
          #need create instead of update
          input[:need_update] = false
        end

        input[:symbol] = COMPANY_LIST[0][input[:company_name]]

        Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config)
          .send(add_target_request_json(input))

        Failure(Response::ApiResult.new(
          status: :processing,
          message: { request_id: input[:request_id], msg: PROCESSING_MSG }
        ))
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :not_support, message: e.to_s))
      end

      def return_target(input)
        target = target_in_database(input[:company_name])
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # following are support methods that other services could use
      def target_in_database(input)
        Repository::Targets.find_company(input[:company_name])
      end

      def target_update_from_news(input)
        symbol = COMPANY_LIST[0][input[:company_name]]
        GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(input[:company_name], symbol)
      rescue StandardError
        raise GN_NOT_FOUND_MSG
      end

      def target_from_news(input)
        symbol = COMPANY_LIST[0][input[:company_name]]
        if symbol.nil?
          Failure(Response::ApiResult.new(status: :not_found, message: GN_NOT_FOUND_MSG))
        else
          GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(input[:company_name], symbol)
        end
      rescue StandardError => e
        print_error(e)
        raise GN_NOT_FOUND_MSG
      end

      def add_target_request_json(input)
        Response::NewsRequest.new(input[:company_name], input[:need_update], input[:symbol], input[:request_id])
          .then { Representer::NewsRequest.new(_1) }
          .then(&:to_json)
      end

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end
    end
  end
end
