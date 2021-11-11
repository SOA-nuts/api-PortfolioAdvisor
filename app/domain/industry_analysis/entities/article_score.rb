# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class ArticleScore

      attr_reader :article

      def initialize(article)
        @article = article
      end

      def score
        # text mining
      end
    end
  end
end