# frozen_string_literal: false

require 'concurrent'

require_relative 'article_mapper'

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: News repo -> Target entity
    class TargetMapper
      def initialize(gn_token, gateway_class = GoogleNews::Api)
        @token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(company)
        data = @gateway.article(company)
        build_entity(company, data['articles'])
      end

      def build_entity(company, data)
        DataMapper.new(company, data, @token, @gateway_class).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(company, data, _token, _gateway_class)
          @company_name = company
          @data = data
          @article_mapper = ArticleMapper.new
          @article_score = 0
        end

        def build_entity
          PortfolioAdvisor::Entity::Target.new(
            company_name: company_name,
            articles: articles,
            updated_at: Date.today,
            score: @article_score
          )
        end

        attr_reader :company_name

        def articles
          sum = 0
          article_num = 0
          puts @data
          articless = @article_mapper.load_several(@data)
          articless.each do |article|
            sum = sum + article.score
            article_num += 1
          end
          @article_score = sum/article_num 
          articless
        end

        def score
          10
        end
      end
    end
  end
end
