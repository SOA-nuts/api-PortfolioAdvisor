# frozen_string_literal: true

module PortfolioAdvisor
  module Repository
    # Repository for Target
    class Targets
      def self.all
        Database::TargetOrm.all.map { |db_target| rebuild_entity(db_target) }
      end

      def self.get_update_at(company_name)
        db_target = Database::TargetOrm
        .where(company_name: company_name)
        .first

        db_target.timestamps
      end

      def self.find_company(company_name)
        db_target = Database::TargetOrm
          .where(company_name: company_name)
          .first
        rebuild_entity(db_target)
      end

      def self.find(entity)
        find_company(entity.company_name)
      end

      def self.update(entity)
        db_target = PersistTarget.new(entity).update
        rebuild_entity(db_target)
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

      # Helper to save target and its articles
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

        def update
          @entity.articles.each do |article|
            db_target.add_article(Articles.db_find_or_create(article))
          end
        end
      end
    end
  end
end
