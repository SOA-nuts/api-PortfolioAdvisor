# frozen_string_literal: false



module PortfolioAdvisor
  # Access article data
  module GoogleNews
    # Maps NewsAPI data to Article Entity
    class ArticleMapper
      def initialize(articles)
        articles.map do |article|
          build_entity(article)
        end
      end

      def build_entity(article)
        DataMapper.new(article).build_entity
      end



      # Extracts specific parameters from data
      class DataMapper
        def initialize(data)
          @data = data
          @publish_mapper
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
          # @data.map { |hash| hash['url'] }
          @data['url']
        end

        def published_at
          # publish_time = @data.map { |hash| hash['publishedAt'] }
          # Publish.new(publish_time)
          # PublishMapper.new(@data['publishedAt'])
          @publish_mapper  = PublishMapper.new(@data['publishedAt'])
          
        end

        def title
          # @data.map { |hash| hash['title'] }
          @data['title']
        end
      end
    end
  end
end
