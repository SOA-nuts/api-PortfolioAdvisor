# frozen_string_literal: false

module PortfolioAdvisor
  # Access article data
  module GoogleNews
    # Maps NewsAPI data to Article Entity
    class ArticleMapper
      def initialize(gn_token, gateway_class = GoogleNews::Api)
        @token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(company)
          data = @gateway.article(company)
          build_entity(data['articles'])
        end
      end

      def build_entity(articles)
        DataMapper.new(articles).build_entity
      end

      # Extracts specific parameters from data
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Article.new(
            urls: urls,
            published_ats: published_ats,
            titles:titles
          )
        end

        private

        def urls
          @data.map { |hash| hash['url'] }
        end

        def published_ats
          publish_time = @data.map { |hash| hash['publishedAt'] }
          Publish.new(publish_time)
        end

        def titles
          @data.map { |hash| hash['title'] }
        end
      end
    end
  end
end
