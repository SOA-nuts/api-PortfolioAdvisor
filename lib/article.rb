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
      @article.map { |h| h['title'] }
    end

    def url
      @article.map { |h| h['url'] }
    end

    def publish
      @publish ||= @data_source.publish(@article.map { |h| h['publishedAt'] })
    end
  end
end
