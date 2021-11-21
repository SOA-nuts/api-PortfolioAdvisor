# frozen_string_literal: true
require_relative 'history'

module Views
  # View for a list of history of a company
  class HistoriesList
    def initialize(histories, company)
      @histories = histories.map { |history| History.new(history) }
      @company = company
    end

    def company
      @company
    end

    def each
      @histories.each do |history|
        yield history
      end
    end

    def any?
      @histories.any?
    end
  end
end
