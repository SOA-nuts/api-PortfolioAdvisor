# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module PortfolioAdvisor
    module Crawler
    # Display content of HTML articles
        class Api
            def initialize(url)
            @url = url
            end

            def crawl
                open_article = Nokogiri::HTML(URI.open(@url))
                open_article.css('p').map(&:text)
            end
        end


    end

end