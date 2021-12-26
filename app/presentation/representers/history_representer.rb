# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Repo information for API output
module PortfolioAdvisor
  module Representer
    # Represent a History entity as Json
    class History < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :updated_at
      property :market_price
      property :long_advice_price
      property :mid_advice_price
      property :short_advice_price
    end
  end
end
