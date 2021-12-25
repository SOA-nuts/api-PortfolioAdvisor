# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'article'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Target < Dry::Struct
      include Dry.Types

      attribute :company_name,      Strict::String
      attribute :articles,          Strict::Array.of(Article)
      attribute :updated_at,        Strict::Date
      attribute :article_score,     Strict::Float
      attribute :bench_price,       Strict::Float
      attribute :grow_score,        Strict::Float  
      attribute :market_price,      Strict::Float

      def to_attr_hash
        to_hash.reject { |key, _| %i[articles].include? key }
      end

      def to_history_hash
        to_hash.reject { |key, _| %i[company_name articles].include? key }
      end
    end
  end
end
