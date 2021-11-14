# frozen_string_literal: false

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: News repo -> Target entity
    class ScoreMapper
      def initialize(content)
        @content = content
      end

      def analyze_content
        return 10
      end
    end
  end
end
