# frozen_string_literal: true

require_relative 'publish'

module NewsArticle
  # Model for Article
  class Article
    def initialize(article_data, data_source)
      @article = article_data
      @data_source = data_source
    end

    def title
      @article['title']
    end

    def url
      @article['url']
    end

    def date
      @date ||= @data_source.publish(@article['publishedAt'])
    end
  end
end