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
                input[:target] = Repository::For.klass(Entity::Target).find_company(input[:requested])


                if input[:target]
                    Success(input)
                else
                    Failure(Response::ApiResult.new(status: :not_found, message: NO_TARGET_ERR))
                end
            rescue StandardError
                Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
            end
        end
    end
end
