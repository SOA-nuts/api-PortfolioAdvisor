# frozen_string_literal: false

require_relative 'score_mapper'

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: News repo -> Target entity
    class ContentMapper
      def initialize(url)#, gateway_class = Crawler::Api) #module Crawler and class Api
        @url = url
        #@gateway = @gateway_class.new(@url)
      end

      def get_content
        content = "hello"#@gateway.crwal
        get_score(content)
      end

      def get_score(content)
        ScoreMapper.new(content).analyze_content
      end
    end
  end
end
