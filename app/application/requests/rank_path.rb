# frozen_string_literal: true

module PortfolioAdvisor
    module Request
      # Application value for the path of a requested target history
      class RankPath
        def initialize(request)
          @request = request
          @path = request.remaining_path
        end
      end
    end
  end
  