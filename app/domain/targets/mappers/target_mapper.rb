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

        @test = yahoo_token
        @gateway_finance_class = YahooFinance::Api
        @gateway_finance = @gateway_finance_class.new(@test)
      end

      def find(company, updated_at, company_symbol)
        data = @gateway.article(company, updated_at)
        summary = @gateway_finance.financial_data(company_symbol)
        # puts summary['quoteSummary']['result']
        build_entity(company, data['articles'], summary['quoteSummary']['result'][0]['financialData'])
      end

      def build_entity(company, data, summary)
        DataMapper.new(company, data, summary).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(company, data, summary)
          @company_name = company
          @data = data
          @article_mapper = ArticleMapper.new
          @bench_price = summary['targetMedianPrice']['raw'].to_i
        end

        def build_entity
          PortfolioAdvisor::Entity::Target.new(
            company_name: company_name,
            articles: articles,
            updated_at: Date.today,
            article_score: article_score,
            bench_price: bench_price
          )
        end

        attr_reader :company_name, :bench_price

        def articles
          @article_mapper.load_several(@data)
        end

        def article_score
          # todo
          2
        end
      end
    end
  end
end
