# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'target_representer'

module PortfolioAdvisor
  module Representer
    # Represents list of Targets for API output
    class TargetsList < Roar::Decorator
      include Roar::JSON

      collection :targets, extend: Representer::Target,
                           class: Representer::OpenStructWithLinks
    end
  end
end
