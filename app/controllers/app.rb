# frozen_string_literal: true

require 'roda'
require 'slim'
require 'yaml'

COMPANY_YAML = 'spec/fixtures/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do
        targets = Repository::For.klass(Entity::Target).all
        view 'home', locals: { targets: targets }
      end

      routing.on 'target' do
        routing.is do
          # POST /target/
          routing.post do
            company = routing.params['company_name'].downcase
            routing.halt 400 if COMPANY_LIST[0][company].nil?

            build_entity(company)

            # Redirect viewer target page
            routing.redirect "target/#{company}"
          end
        end

        routing.on String do |company|
          # GET /target/company
          routing.get do
            # Get project from database
            target = Repository::For.klass(Entity::Target)
              .find_company(company)

            # Calculate score of the article
            article_scores = Mapper::Score.new(target.articles).target_summary
              
            view 'target', locals: { target: target, article_scores: article_scores}
          end
        end
      end
    end

    def build_entity(company)
      #check last update: nil->nothing in DB
      update_at = Repository::Target.get_update_at(company)

      if update_at == Date.today
        Repository::Target.find_company(company_name)
      elsif update_at.nil?
        # Get target from news api
        target = GoogleNews::TargetMapper
        .new(App.config.GOOGLENEWS_TOKEN)
        .find(company, update_at)

        # Add target to database
        Repository::For.entity(target).create(target)
      else
        # Get target from news api
        target = GoogleNews::TargetMapper
        .new(App.config.GOOGLENEWS_TOKEN)
        .find(company, update_at)

        # Add articles to database
        Repository::Target.find_company(company_name)
        Repository::For.entity(target).update(target)
      end
    end

  end
end
