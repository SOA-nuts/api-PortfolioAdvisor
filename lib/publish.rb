# frozen_string_literal: true

require 'date'
require_relative 'article'

module NewsArticle
  # Model for Publish
  class Publish
    def initialize(publish)
      @publish = publish.map { |date| DateTime.strptime(date, '%Y-%m-%dT%H:%M:%S%z') }
    end

    def date
      @publish.map { |x| x.strftime('%Y-%m-%d') }
    end

    def time
      @publish.map { |x| x.strftime('%H:%M:%S') }
    end
  end
end
