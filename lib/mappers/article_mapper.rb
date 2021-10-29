# frozen_string_literal: false

module NewsArticle
  # Access article data
  module GoogleNews
    # Maps NewsAPI data to Article Entity
    class ArticleMapper
      def initialize(gn_token, gateway_class = GoogleNews::Api)
        @token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(article_data['articles'])
        @gateway.article(article_data['articles']).map do |data|
          ArticleMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        ArticleMapper.new(data).build_entity
      end

      # Extracts specific parameters from data
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Article.new(
            website_address: website_address,
            piblication_date: publication_date,
            title:title
          )
        end

        private

        def website_address
          @data['url']
        end

        def publication_date
          @data['publishedAt']
        end

        def topic
          @data['title']
        end
      end
    end
  end
end
