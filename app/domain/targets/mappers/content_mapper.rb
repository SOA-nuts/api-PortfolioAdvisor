# frozen_string_literal: true

require_relative 'score_mapper'

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: url -> call score mapper
    class ContentMapper
      def initialize(url, gateway_class = Crawler::Api)
        @url = url
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@url)
      end

      def crawl_content
        content = @gateway.crawl
        get_score(content)
      end

      def get_score(content)
        ScoreMapper.new(content).analyze_content
      end
    end
  end
end
