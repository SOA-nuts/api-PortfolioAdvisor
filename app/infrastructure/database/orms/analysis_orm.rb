# frozen_string_literal: true

require 'sequel'

module PortfolioAdvisor
  module Database
    # Object-Relational Mapper for articles
    class AnalysisOrm < Sequel::Model(:analyses)
      many_to_one :target,
                  class: :'PortfolioAdvisor::Database::TargetOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(analysis_info)
        first(company_id: analysis_info[:company_id], analyzed_at: analysis_info[:analyzed_at]) || create(analysis_info)
      end
    end
  end
end
