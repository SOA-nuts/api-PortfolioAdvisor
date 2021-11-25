# frozen_string_literal: true

require 'dry/monads'

module PortfolioAdvisor
  module Service
    # Retrieves array of all listed project entities
    class ListTargets
      include Dry::Monads::Result::Mixin

      def call(targets_list)
        targets = Repository::For.klass(Entity::Target).find_companys(targets_list)

        Success(targets)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
