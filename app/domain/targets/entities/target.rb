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
      # attribute :stock_symbol,      Strict::String
      attribute :updated_at,         Strict::Date
      attribute :score,             Strict::Integer
      
      def to_attr_hash
        to_hash.reject { |key, _| %i[articles].include? key }
      end

      def to_history_hash
        test = to_hash.reject { |key, _| %i[company_name articles].include? key }
        test.each do |key, value|
          puts "#{key}:#{value}"
        end
        to_hash.reject { |key, _| %i[company_name articles].include? key }
      end

    end
  end
end
