# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'publish'
module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Article < Dry::Struct
      include Dry.Types

      attribute :title,             Strict::String
      attribute :url,               Strict::String
      # attribute :published_at,      Strict::Publish
    end
  end
end
