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
      @publish.map { |info| info.strftime('%Y-%m-%d') }
    end

    def time
      @publish.map { |info| info.strftime('%H:%M:%S') }
    end
  end
end
