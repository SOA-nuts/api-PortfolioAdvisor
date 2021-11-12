# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class ArticleScore

      attr_reader :article, :content

      def initialize(article, content)
        @article = article
        @content = content
      end

      def score
        return 10 # replace with text mining logic
      end
    end
  end
end