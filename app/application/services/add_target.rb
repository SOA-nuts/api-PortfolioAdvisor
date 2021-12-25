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
      step :store_target

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      NOT_SUPPORT_MSG = 'this compnay is not on our supporting list'
      GN_NOT_FOUND_MSG = 'Could not find related articles of the compnay on Google News'
      PROCESSING_MSG = 'Adding the project'

      def find_target(input)
        # if (target = target_in_database(input))
        #   # not need update
        #   if target.updated_at == Date.today
        #     input[:local_target] = target

        #   # need update
        #   else
        #     input[:update_target] = target_update_from_news(target)
        #   end
        # else
        #   input[:remote_target] = target_from_news(input)
        # end
        # Success(input)
        # rescue StandardError => e
        #   print_error(e)
        #   raise GN_NOT_FOUND_MSG
        # end

        #in database
        return Success(input) if target_in_database(input)
        
        #get from news api(from worker)
        if COMPANY_LIST[0][input[:company_name]].nil?
          Failure(Response::ApiResult.new(status: :not_found, message: NOT_SUPPORT_MSG))
        else
          Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config)
          .send(add_target_request_json(input))

          Failure(Response::ApiResult.new(
            status: :processing,
            message: { request_id: input[:request_id], msg: PROCESSING_MSG }
          ))
        end

        rescue StandardError => e
          print_error(e)
          Failure(Response::ApiResult.new(status: :not_support, message: e.to_s))
        end

      def store_target(input)
        # target =
        #   if (new_target = input[:remote_target])
        #     Repository::For.entity(new_target).create(new_target)
        #   elsif (update_target = input[:update_target])
        #     Repository::For.entity(update_target).update(update_target)
        #   else
        #     input[:local_target]
        #   end
        target = target_in_database(input[:company_name])

        Success(Response::ApiResult.new(status: :created, message: target))
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # following are support methods that other services could use
      def target_in_database(input)
        Repository::Targets.find_company(input[:company_name])
      end

      # def target_update_from_news(target)
      #   GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(target.company_name)
      # rescue StandardError
      #   raise GN_NOT_FOUND_MSG
      # end

      # def target_from_news(input)
      #   if COMPANY_LIST[0][input[:company_name]].nil?
      #     Failure(Response::ApiResult.new(status: :not_found, message: NOT_SUPPORT_MSG))
      #   else
      #     Messaging::Queue.new(App.config.CLONE_QUEUE_URL, App.config)
      #     .send(add_target_request_json(input))

      #     Failure(Response::ApiResult.new(
      #       status: :processing,
      #       message: { request_id: input[:request_id], msg: PROCESSING_MSG }
      #     ))
      #   end
      # rescue StandardError => e
      #   print_error(e)
      #   raise GN_NOT_FOUND_MSG
      # end

      def add_target_request_json(input)
        Response::NewsRequest.new(input[:company_name], input[:request_id])
          .then { Representer::NewsRequest.new(_1) }
          .then(&:to_json)
      end

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end
    end
  end
end
