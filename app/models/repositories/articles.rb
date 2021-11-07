# frozen__string_literal: true

require_relative 'targets'

module PortfolioAdvisor
  module Repository
    # Repository for Article Entities
    class Articles
      def self.all
        PortfolioAdvisor::Database::ArticleOrm.all.map { |db_article| rebuild_entity(db_article) }
      end

      def self.find_company(company)
        # SELECT * FROM `articles` LEFT JOIN `targets`
         #ON (`targets`.`id` = `articles`.`company_id`)
        #WHERE ((`company_name` = 'company') 
        db_article = PortfolioAdvisor::Database::ArticleOrm
          .left_join(:targets, id: :company_id)
          .where(company_name: company)
          .first
        rebuild_entity(db_article)
      end

      def self.find(entity)
        find_company(entity.company_name)
      end

      def self.find_id(id)
        db_record = PortfolioAdvisor::Database::ArticleOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_company_name(company_name)
        db_record = PortfolioAdvisor::Database::ArticleOrm.first(company_name: company_name)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Company already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Article.new(
          db_record.to_hash.merge(
            company: Target.rebuild_entity(db_record.company),
            articles: Target.rebuild_many(db_record.articles)
          )
        )
      end

      # Helper class to persist articles and its targets to database
      class PersistArticle
        def initialize(entity)
          @entity = entity
        end

        def create_article
          PortfolioAdvisor::Database::ArticleOrm.create(@entity.to_attr_hash)
        end

        def call
          company =Targets.db_find_or_create(@entity.company)

          create_article.tap do |db_article|
            db_article.update(company: company)

            @entity.articles.each do |articles|
              db_project.add_article(Target.db_find_or_create(article))
            end
          end
        end
      end
    end
  end
end
