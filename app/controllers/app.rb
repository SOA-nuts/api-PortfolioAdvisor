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

      # GET 
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

            view 'target', locals: {target: target}
          end
        end
      end

      routing.on 'history' do
        puts "in app 56"
        routing.is do
            # Redirect viewer target page
            routing.redirect "history/#{company}"
          end
        end

        routing.on String do |company|
          # GET /target/company
          routing.get do
            # Get project from database
            histories = Repository::Histories.find_company(company)

            # view '', locals: {histories: histories}
          end
        end
      end
    

    def build_entity(company)

      company_record = Repository::Targets.find_company(company)

      if company_record.nil?
        target = GoogleNews::TargetMapper
        .new(App.config.GOOGLENEWS_TOKEN)
        .find(company, nil)
        Repository::For.entity(target).create(target)
        
      elsif company_record.updated_at != Date.today
        target = GoogleNews::TargetMapper
        .new(App.config.GOOGLENEWS_TOKEN)
        .find(company, company_record.updated_at)
        Repository::For.entity(target).update(target)
      end
    end
  end
end
