# frozen_string_literal: true

module PortfolioAdvisor
  module Response
    # Scores for articles of target
    TargetArticleScore = Struct.new(:company_name, :updated_at, :articles,
                                    :market_price, :long_advice_price, :mid_advice_price, :short_advice_price)
  end
end
