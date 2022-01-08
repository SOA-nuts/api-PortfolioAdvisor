# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Analyzes results to a history
    class ResultRank
      include Dry::Transaction

      step :retrieve_rank
      
      private

      NO_RANK_ERR = 'Rank not found'
      DB_ERR = 'Having trouble accessing the database'

      def retrieve_rank(input)
        if input[:rank] = Repository::Rank.find_rank
            Response::Rank.new(input[:rank])
            .then do |rank|
                result = Response::ApiResult.new(status: :ok, message: rank.rank)
                Success(Response::ApiResult.new(status: :ok, message: rank.rank))
            end
        else
          Failure(Response::ApiResult.new(status: :not_found, message: NO_RANK_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end
    end
  end
end
