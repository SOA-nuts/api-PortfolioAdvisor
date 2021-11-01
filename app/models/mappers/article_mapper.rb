# frozen_string_literal: false

# require_relative 'publish_mapper'
require 'date'

module PortfolioAdvisor
  # Access article data
  module GoogleNews
    # Maps NewsAPI data to Article Entity
    class ArticleMapper
      def initialize
        # articles.map do |article|
        #   build_entity(article)
        # end
      end

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
          @publish_mapper = PublishMapper.new(@data['publishedAt'])
        end

        def build_entity
          PortfolioAdvisor::Entity::Article.new(
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
          # @publish_mapper.build_entity
          DateTime.strptime(@data['publishedAt'], '%Y-%m-%dT%H:%M:%S%z')
        end

        def title
          @data['title']
        end
      end
    end
  end
end
