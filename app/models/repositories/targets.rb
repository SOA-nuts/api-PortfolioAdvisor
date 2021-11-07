# frozen_string_literal: true

module PortfolioAdvisor
  module Repository
    # Repository for Target
    class Targets
      def self.all
        Database::TargetOrm.all.map { |db_target| rebuild_entity(db_target) }
      end

      def self.find_company(company_name)
        # SELECT * FROM `targets` 
        # WHERE ((`company_name` = 'company_name'))
        db_target = Database::TargetOrm
          .left_join(:articles, company_id: :id)
          .where(company_name: company_name)
          .first
        rebuild_entity(db_target)
      end

      def self.find(entity)
        find_id(entity.id)
      end

      def self.find_id(id)
        db_record = Database::TargetOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Target already exists' if find(entity)

        db_target = PersistTarget.new(entity).call
        rebuild_entity(db_target)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Target.new(
          db_record.to_hash.merge(
            articles: Articles.rebuild_many(db_record.articles)
          )
        )    
      end
      class PersistTarget
        def initialize(entity)
          @entity = entity
        end

        def create_target
          Database::TargetOrm.create(@entity.to_attr_hash)
        end

        def call
          create_target.tap do |db_target|

            @entity.articles.each do |article|
              db_target.add_article(Articles.db_find_or_create(article))
            end
          end
        end
      end
    end
  end
end
