# frozen_string_literal: false

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: News repo -> Target entity
    class ScoreMapper
      def initialize(content)#, gateway_class = TextMining::Api) #module TextMining and class Api
        @content = content
        #@gateway = @gateway_class.new(@content)
      end

      def analyze_content
        #@gateway.mine
        return 10
      end
    end
  end
end
