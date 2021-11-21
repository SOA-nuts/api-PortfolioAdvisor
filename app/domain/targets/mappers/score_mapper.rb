# frozen_string_literal: false

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: content -> score
    class ScoreMapper
      def initialize(content)
        @content = content
      end

      def analyze_content
        10
      end
    end
  end
end
