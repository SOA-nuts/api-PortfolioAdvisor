# frozen_string_literal: true

module PortfolioAdvisor
    module Mapper
      # Git contributions parsing and reporting services
      class Score
        def initialize(articles)
          @articles = articles
          @contents = Crawler.new(articles).crawl
        end
  
        def target_summary
          @articles.each_with_index  do |article, index|
            Mapper::ArticleScore.new(article, @contents[index]).build_entity
          end
        end
      end
    end
  end