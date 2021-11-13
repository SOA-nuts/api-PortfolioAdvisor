# frozen__string_literal: true

module PortfolioAdvisor
    module Repository
      # Repository for Analysis Entities
      class Histories
        def self.find_id(id)
          rebuild_entity Database::HistoryOrm.first(id: id)
        
        end
        def self.all
          Database::HistoryOrm.all
        end
        
        def self.db_find_or_create(entity)
          # test = { company_name: "appel", updated_at: Date.today, score: 300 }
          # puts test.class
          Database::HistoryOrm.find_or_create(entity)
        end
        
      end
    end
  end
  