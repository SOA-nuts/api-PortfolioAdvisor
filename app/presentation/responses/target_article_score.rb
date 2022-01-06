# frozen_string_literal: true

module PortfolioAdvisor
  module Response
    # Scores for articles of target
    TargetArticleScore = Struct.new(:company_name, :updated_at, :articles,
                                    :long_term_advice, :mid_term_advice, :short_term_advice)
  end
end
