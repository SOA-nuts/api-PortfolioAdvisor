# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
    module Service
        # Analyzes results to a history
        class ResultHistory
            include Dry::Transaction

            step :retrieve_remote_history

            private

            NO_HISTORY_ERR = 'History not found'
            DB_ERR = 'Having trouble accessing the database'

            def retrieve_remote_history(input)
                input[:histories] = Repository::Histories.find_company(input[:requested].company_name)

                if input[:histories]
                    Response::HistoryScore.new(input[:histories])
                    .then do |show|
                      Success(Response::ApiResult.new(status: :ok, message: show))
                    end
                else
                    Failure(Response::ApiResult.new(status: :not_found, message: NO_HISTORY_ERR))
                end
            rescue StandardError
                Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
            end
        end
    end
end
