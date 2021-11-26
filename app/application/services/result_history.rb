# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
    module Service
        # Analyzes results to a history
        class ResultHistory
            include Dry::Transaction

            step :ensure_watched_history
            step :retrieve_remote_history

            private

            def ensure_watched_history(input)
                if input[:watched_list].include? input[:requested]
                    Success(input)
                else
                    Failure('Please first request this target to be added to your list')
                end
            end

            def retrieve_remote_history(input)
                input[:history] = Repository::Histories.find_company(input[:requested])
                input[:history] ? Success(input) : Failure('History not found')
            rescue StandardError
                Failure('Having trouble accessing the database')
            end
        end
    end
end
