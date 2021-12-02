# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Retrieves array of all listed project entities
    class ListTargets
      include Dry::Transaction

      step :validate_list
      step :retrieve_taregts

      private

      DB_ERR = 'Cannot access database'

      # Expects list of movies in input[:list_request]
      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def retrieve_taregts(input)
        test = Repository::For.klass(Entity::Target).find_companys(input[:list])
          .then { |targets| Response::TargetsList.new(targets) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR)
        )
      end
    end
  end
end
