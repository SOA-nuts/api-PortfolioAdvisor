# frozen_string_literal: false

require_relative 'article_mapper'

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: News repo -> Target entity
    class TargetMapper
      def initialize(gn_token, yahoo_token, gateway_class = GoogleNews::Api)
        @gn_token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@gn_token)

        @finance_token = yahoo_token
      end

      def find(company, updated_at, company_symbol)
        data = @gateway.article(company, updated_at)
        build_entity(company, data['articles'], @finance_token, company_symbol)
      end

      def build_entity(company, data, token, company_symbol)
        DataMapper.new(company, data, token, company_symbol).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(company, data, token, company_symbol)
          @company_name = company
          @data = data
          @article_mapper = ArticleMapper.new
          @finance_data = PortfolioAdvisor::YahooFinance::FinanceMapper.new(token).find(company_symbol)
        end

        def build_entity
          PortfolioAdvisor::Entity::Target.new(
            company_name: company_name,
            articles: articles,
            updated_at: Date.today,
            article_score: article_score,
            bench_price: bench_price,
            market_price: market_price,
            grow_score: grow_score
          )
        end

        attr_reader :company_name

        def articles
          @article_mapper.load_several(@data)
        end

        def article_score
          # todo
          2.0
        end

        def bench_price
          @finance_data.bench_price
        end

        def market_price
          @finance_data.market_price
        end

        def grow_score
          @finance_data.grow_score
        end

      end
    end
  end
end
