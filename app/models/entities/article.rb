# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'publish'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Articles < Dry::Struct
      include Dry.Types

      attribute :titles,             Strict::Array.of(String)
      attribute :urls,               Strict::Array.of(String)
      attribute :published_ats,     Strict::Array.of(Publish)
    end
  end
end
