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

            def retrieve_remote_target(input)
                input[:history] = Repository::Histories.find_company(input[:requested])

                if input[:project]
                    Success(input)
                else
                    Failure(Response::ApiResult.new(status: :not_found, message: NO_HISTORY_ERR))
                end
            rescue StandardError
                Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
            end
        end
    end
end
