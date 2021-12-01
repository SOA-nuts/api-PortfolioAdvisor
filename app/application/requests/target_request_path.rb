# frozen_string_literal: true

module PortfolioAdvisor
    module Request
      # Application value for the path of a requested project
      class TargetPath
        def initialize(company_name, request)
          @company_name = company_name
          @request = request
          @path = request.remaining_path
        end
  
        attr_reader :company_name
  
      end
    end
end