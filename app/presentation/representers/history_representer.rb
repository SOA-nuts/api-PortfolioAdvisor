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
      property :score
    end
  end
end
