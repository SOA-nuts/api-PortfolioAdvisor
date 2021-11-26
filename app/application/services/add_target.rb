# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Transaction to store target from NEWS API to database
    class AddTarget
        include Dry::Transaction

        step :parse_target
        step :find_target
        step :store_target

        private

        def parse_target(input)
            if input.success?
                #set input[:company_name]
                Success(company_name: input[:company_name])
            else
                Failure("URL #{input.errors.messages.first}")
            end
        end

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
            Failure(error.to_s)
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
            Success(target)
        rescue StandardError => error
            puts error.backtrace.join("\n")
            Failure('Having trouble accessing the database')
        end

        # following are support methods that other services could use
        def target_in_database(input)
            Repository::Targets.find_company(input[:company_name])
        end

        def target_update_from_news(target)
            GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(target.company_name, target.updated_at)
        rescue StandardError
            raise 'Could not get target from newsApi.'
        end

        def target_from_news(input)
            GoogleNews::TargetMapper.new(App.config.GOOGLENEWS_TOKEN).find(input[:company_name], nil)
        rescue StandardError
            raise 'Could not get target from newsApi.'
        end
    end
  end
end
