# frozen_string_literal: true

module PortfolioAdvisor
  module Repository
    # Repository for Target
    class Target
      def self.find_id(id)
        rebuild_entity PortfolioAdvisor::Database::TargetOrm.first(id: id)
      end

      def self.find_company(company_name)
        rebuild_entity PortfolioAdvisor::Database::TargetOrm.first(company_name: company_name)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Target.new(
          id: db_record.id,
          company_name: db_record.company_name,
          title: db_record.title,
          url: db_record.url
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_target|
          Target.rebuild_entity(db_target)
        end
      end

      def self.db_find_or_create(entity)
        PortfolioAdvisor::Database::TargetOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
PortfolioAdvisor::Repository::Target.find_company(company_name: 'Apple')
