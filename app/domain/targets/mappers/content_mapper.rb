# frozen_string_literal: false

require_relative 'score_mapper'

module PortfolioAdvisor
  module GoogleNews
    class ContentMapper
      def initialize(url, gateway_class = Crawler::Api)
        @url = url
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@url)
      end

      def get_content
        content = @gateway.crawl
        get_score(content)
      end

      def get_score(content)
        ScoreMapper.new(content).analyze_content
      end
    end
  end
end
