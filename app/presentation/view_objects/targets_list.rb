# frozen_string_literal: true

require_relative 'target'

module Views
  # View for a list of target entities
  class TargetsList
    def initialize(targets)
      @targets = targets.map.with_index { |targ, i| Target.new(targ, i) }
    end

    def each(&block)
      @targets.each(&block)
    end

    def any?
      @targets.any?
    end
  end
end
