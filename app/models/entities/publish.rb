# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require 'date'
require_relative 'article'

module NewsArticle
  module Entity
    # Domain entity for publishing date
    class Member < Dry::Struct
      include Dry.Types

      attribute :publication_date, Strict::String
    end
  end
end
