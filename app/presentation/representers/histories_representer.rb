# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'history_representer'

module PortfolioAdvisor
  module Representer
    # Represents list of Targets for API output
    class HistoriesList < Roar::Decorator
      include Roar::JSON

      collection :histories, extend: Representer::History,
                             class: Representer::OpenStructWithLinks
    end
  end
end
