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
      # @article['title']
      @article.map { |h| h['title'] }
    end

    def url
      # @article['url']
      @article.map { |h| h['url'] }
    end

    def date
       @date ||= @data_source.publish(@article['publishedAt']).date
    end
    def time
      @date ||= @data_source.publish(@article['publishedAt']).time

    end
    # this is for testing
    def test
       @data_source.publish(@article.map{|h| h['publishedAt'] }).time
     end

     def show_type
       puts @article[0].class
     end

    def show_all
      puts @article[0]
    end
    # end testing
  end
end
