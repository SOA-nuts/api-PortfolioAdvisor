# frozen__string_literal: true

module PortfolioAdvisor
    module Repository
      # Repository for Analysis Entities
      class Analyses
        def self.find_id(id)
          rebuild_entity Database::AnalysisOrm.first(id: id)
        end
        
        def self.db_find_or_create(entity)
          Database::AnalysisOrm.create_entity(entity.to_hash)
        end
        
      end
    end
  end
  