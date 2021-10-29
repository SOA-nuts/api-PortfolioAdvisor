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
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'target' do
        routing.is do
          # POST /target/
          routing.post do
            cmp_name = routing.params['company_name'].downcase
            routing.halt 400 if COMPANY_LIST[cmp_name].nil?

            routing.redirect "target/#{cmp_name}"
          end
        end

        routing.on String do |company|
          # GET /target/company
          routing.get do
            articles = GoogleNews::ArticleMapper
              .new(GOOGLENEWS_TOKEN)
              .find(cmp_name)

            view 'target', locals: { target: articles, cmp_name : COMPANY_LIST[cmp_name] }
          end
        end
      end
    end
  end
end