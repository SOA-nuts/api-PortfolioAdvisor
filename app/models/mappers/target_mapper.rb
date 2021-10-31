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
        end

        def build_entity
          PortfolioAdvisor::Entity::Target.new(
            company_name: company_name,
            articles: articles
          )
        end

        attr_reader :company_name

        def articles
          @article_mapper.load_several(@data)
        end
      end
    end
  end
end
