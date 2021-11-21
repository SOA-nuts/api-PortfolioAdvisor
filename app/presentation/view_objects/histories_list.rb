# frozen_string_literal: true
require_relative 'history'

module Views
  # View for a list of history entities
  class HistoriesList
    def initialize(histories)
      @histories = histories.map.with_index { |hist, i| History.new(hist, i) }
    end

    def each
      @histories.each do |hist|
        yield hist
      end
    end

    def any?
      @histories.any?
    end
  end
end
