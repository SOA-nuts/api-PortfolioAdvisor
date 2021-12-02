# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Transaction to store target from NEWS API to database
    class AddTarget
        include Dry::Transaction

        step :find_target
        step :store_target

        private

        DB_ERR_MSG = 'Having trouble accessing the database'
        GN_NOT_FOUND_MSG = 'Could not find related articels of the compnay on Google News'

        def find_target(input)
            if (target = target_in_database(input))
                #not need update
                if(target.updated_at ==  Date.today)
                    input[:local_target] = target

                #need update
                else
                    input[:update_target] = target_update_from_news(target)
                end
            else    
                input[:remote_target] = target_from_news(input)
            end
            Success(input)
        rescue StandardError => error
            Failure(Response::ApiResult.new(status: :not_support, message: error.to_s))
        end

        def store_target(input)
            target =
                if (new_target = input[:remote_target])
                    Repository::For.entity(new_target).create(new_target)
                elsif(update_target = input[:update_target])
                    Repository::For.entity(update_target).update(update_target)
                else
                    input[:local_target]
                end
            
            Success(Response::ApiResult.new(status: :created, message: target))
            
        rescue StandardError => error
            puts error.backtrace.join("\n")
            Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
        end

        # following are support methods that other services could use
        def target_in_database(input)
            Repository::Targets.find_company(input[:company_name])
        end

        def target_update_from_news(target)
            GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(target.company_name, target.updated_at)
        rescue StandardError
            raise GN_NOT_FOUND_MSG
        end

        def target_from_news(input)
            GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(input[:company_name], nil)
        rescue StandardError
            raise GN_NOT_FOUND_MSG
        end
    end
  end
end
