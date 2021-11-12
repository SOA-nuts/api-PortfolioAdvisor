# frozen_string_literal: true

module PortfolioAdvisor
    module Entity
        class TargetScore
            attr_reader :company_name, :articles

            def initialize(company_name:, articles:)
              @company_name = company_name
              @articles = articles
            end
        end
    end
end