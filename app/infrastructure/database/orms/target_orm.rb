# frozen_string_literal: true

require 'sequel'

module PortfolioAdvisor
  module Database
    # Object Relational Mapper for Target Entities
    class TargetOrm < Sequel::Model(:targets)
      one_to_many :articles,
                  class: :'PortfolioAdvisor::Database::ArticleOrm',
                  key: :company_id

      plugin :timestamps, update_on_create: true, update: :updated_on

      # def self.find_or_create(target_info)
      #   first(company_name: target_info[:company_name]) || create(target_info)
      # end
    end
  end
end
