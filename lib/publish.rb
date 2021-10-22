# frozen_string_literal: true
require 'date'
require_relative 'article'

module NewsArticle
  class Publish
    def initialize(publish)
      @publish = publish.map { |date| DateTime.strptime(date,'%Y-%m-%dT%H:%M:%S%z')}
      puts @publish[0]
    end
    def date
      @date=@publish.map{|x| x.strftime('%Y-%m%-d')} 
    end
    def time
      @time=@publish.map{|x| x.strftime('%H:%M:%S')}
    end
  end
end
