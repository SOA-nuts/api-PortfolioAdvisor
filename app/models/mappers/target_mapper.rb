# frozen_string_literal: false

require_relative 'article_mapper'

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: Github repo -> Project entity
    class TargetMapper
      def initialize(gn_token, gateway_class = GoogleNews::Api)
        @token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(company)
        data = @gateway.article(company)
        build_entity(data['articles'])
      end

      def build_entity(data)
        DataMapper.new(data, @token, @gateway_class).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, token, gateway_class)
          @data = data
        end

        def build_entity
          PortfolioAdvisor::Entity::Target.new(
            articles: articles
          )
        end

        def articles
          @article_mapper.ArticleMapper.new(@data)
        end
      end
    end
  end
end