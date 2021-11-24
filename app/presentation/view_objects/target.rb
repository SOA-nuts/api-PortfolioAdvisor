# frozen_string_literal: true

module Views
  # View for a target entities
  class Target
    def initialize(target, index = nil)
      @target = target
      @index = index
    end

    def entity
      @target
    end

    def history_link
      "history/#{company_name}"
    end

    def company_name
      @target.company_name
    end

    def index_str
      "target[#{@index}]"
    end

    def date_updated
      @target.updated_at
    end

    def list_of_articles
      @target.articles
    end
  end
end
