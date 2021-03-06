# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Analyzes results to a target
    class ResultTarget
      include Dry::Transaction

      step :retrieve_remote_target

      private

      NO_TARGET_ERR = 'Target not found'
      DB_ERR = 'Having trouble accessing the database'

      def retrieve_remote_target(input)
        if (input[:target] = Repository::For.klass(Entity::Target).find_company(input[:requested].company_name))
          Response::TargetArticleScore.new(input[:target].company_name, input[:target].updated_at,
                                           input[:target].articles, input[:target].long_term_advice,
                                           input[:target].mid_term_advice, input[:target].short_term_advice)
            .then do |analysis|
            Success(Response::ApiResult.new(status: :ok, message: analysis))
          end
        else
          Failure(Response::ApiResult.new(status: :not_support, message: NO_TARGET_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end
    end
  end
end
