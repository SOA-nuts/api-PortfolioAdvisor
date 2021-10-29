# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'publish'

module NewsArticle
  module Entity
    # Domain entity for any article
    class ArticleContent < Dry::Struct
      include Dry.Types

      attribute :topic, Strict::String
      attribute :website_address, Strict::String
      attribute :publication_date, Publish
    end
  end
end
