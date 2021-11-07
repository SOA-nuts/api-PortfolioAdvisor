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

            # Get target from news api
            target = GoogleNews::TargetMapper
              .new(App.config.GOOGLENEWS_TOKEN)
              .find(company)

            # Add target to database
            Repository::For.entity(target).create(target)

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

            view 'target', locals: { target: target }
          end
        end
      end
    end
  end
end
