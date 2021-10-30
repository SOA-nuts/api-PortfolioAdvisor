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
    end
  end
end
