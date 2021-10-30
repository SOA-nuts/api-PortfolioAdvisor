# frozen_string_literal: true

require_relative 'publish'

module NewsArticle
  # Model for Article, article_data is an array of hash
  class Article
    def initialize(article_data, data_source)
      @article = article_data
      @data_source = data_source
    end

    def title
      @article.map { |hash| hash['title'] }
    end

    def url
      @article.map { |hash| hash['url'] }
    end

    def publish
      publish_time = @article.map { |hash| hash['publishedAt'] }
      Publish.new(publish_time)
    end
  end
end