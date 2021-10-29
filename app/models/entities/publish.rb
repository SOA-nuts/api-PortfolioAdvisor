# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'
require 'date'
require_relative 'article'

module PortfolioAdvisor
  module Entity
    # Domain entity for publishing date
    class Publish < Dry::Struct
      include Dry.Types

      attribute :dates, Strict::Array.of(String)
      attribute :times, Strict::Array.of(String)
    end
  end
end
