# frozen_string_literal: true

module PortfolioAdvisor
  module Mapper
    # Articel score analysis
    class Score
      attr_reader :folder_name,
      :contributions_reports

      def initialize(target)
        @company_name = target.company_name
        @articles = target.articles
        @contents = "gggggggggggggggggggggggggggggggggggggggggggggggggggg"
      end

      def build_entity
        Entity::TargetScore.new(
          company_name: @company_name,
          articles: article_summaries
        )
      end

      def article_summaries
        @articles.each_with_index.map do |article, index|
          Mapper::ArticleScore.new(article, @contents[index]).build_entity
        end
      end
    end
  end
end