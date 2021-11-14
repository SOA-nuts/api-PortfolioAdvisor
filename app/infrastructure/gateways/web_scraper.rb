# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require_relative 'google_news_api'

module PortfolioAdvisor
  module GoogleNews
    # Display content of HTML articles
    class WebScraper
      def initialize(gn_token, gateway_class = GoogleNews::Api)
        @token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      api_articles = @gateway.article('business', 2)
      api_articles['articles'].each do |value|
        article_url = value['url']
        open_article = Nokogiri::HTML(URI.open(article_url))
        open_article.css('p').map(&:text)
      end
    end
  end
end
