# frozen_string_literal: true

module PortfolioAdvisor
  module Response
    # Scores for articles of target
    TargetArticleScore = Struct.new(:company_name, :updated_at, :score, :articles)
  end
end