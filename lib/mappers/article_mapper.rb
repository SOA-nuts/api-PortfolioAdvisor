# frozen_string_literal: false

module NewsArticle
  # Access article data
  module GoogleNews
    # Maps NewsAPI data to Article Entity
    class ArticleMapper
      def initialize; end

      def load_several(articles)
        articles.map do |article|
          ArticleMapper.build_entity(article)
        end
      end

      def self.build_entity(article)
        DataMapper.new(article).build_entity
      end

      # Extracts specific parameters from data
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          NewsArticle::Entity::Article.new(
            url: url,
            published_at: published_at,
            title: title
          )
        end

        private

        def url
          @data['url']
        end

        def published_at
          @data['publishedAt']
        end

        def title
          @data['title']
        end
      end
    end
  end
end
