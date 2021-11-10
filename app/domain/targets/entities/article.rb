# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require 'date'

# require_relative 'publish'
module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Article < Dry::Struct
      include Dry.Types

      attribute :title,             Strict::String
      attribute :url,               Strict::String
      attribute :published_at,      Strict::DateTime
      # attribute :published_date, Strict::String
      # attribute :published_time, Strict::String
      def to_attr_hash
        to_hash.reject { |key, _| %i[title url published_at].include? key }
      end
    end
  end
end
