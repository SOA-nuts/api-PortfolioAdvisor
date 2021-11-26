# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
    module Service
        # Analyzes results to a target
        class ResultTarget
            include Dry::Transaction

            step :ensure_watched_target
            step :retrieve_remote_target

            private

            def ensure_watched_target(input)
                if input[:watched_list].include? input[:requested]
                    Success(input)
                else
                    Failure('Please first request this target to be added to your list')
                end
            end

            def retrieve_remote_target(input)
                input[:target] = Repository::For.klass(Entity::Target).find_company(input[:requested])
                Success(input)
            rescue StandardError
                Failure('Having trouble accessing the database')
            end
        end
    end
end
