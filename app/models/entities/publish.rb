# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require 'date'

module PortfolioAdvisor
  module Entity
    # Domain entity for publishing date
    class Publish < Dry::Struct
      include Dry.Types

      attribute :date, Strict::String
      attribute :time, Strict::String
    end
  end
end
