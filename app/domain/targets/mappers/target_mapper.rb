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
          @articles = ArticleMapper.new.load_several(data)
          @finance_data = PortfolioAdvisor::YahooFinance::FinanceMapper.new(token).find(company_symbol)
        end

        def build_entity
          @article_score = article_score
          @bench_price =  bench_price
          @grow_score =  grow_score

          PortfolioAdvisor::Entity::Target.new(
            company_name: company_name,
            updated_at: Date.today,
            articles: articles,
            market_price: market_price,
            long_advice_price: advice_price(0.02, 0.18),
            mid_advice_price: advice_price(0.1, 0.1),
            short_advice_price: advice_price(0.18, 0.2)
          )
        end

        attr_reader :company_name, :articles

        def article_score
          @articles.map { |article| article.score }.sum / @articles.size / 100
        end

        def grow_score
          @finance_data.grow_score
        end

        def bench_price
          @finance_data.bench_price
        end

        def market_price
          @finance_data.market_price
        end

        def advice_price(article_weight, grow_weight)
          @bench_price*(1+(@article_score*article_weight)+(@grow_score*grow_weight))
        end
      end
    end
  end
end
