# frozen_string_literal: true

require_relative 'history'

module Views
  # View for a list of history of a company
  class HistoriesList
    def initialize(histories, company)
      @histories = histories.map { |history| History.new(history) }
      @company = company
    end

    attr_reader :company

    def each(&block)
      @histories.each(&block)
    end

    def any?
      @histories.any?
    end
  end
end
