# frozen_string_literal: true

require 'roda'
require 'slim'
require 'yaml'

COMPANY_YAML = 'spec/fixtures/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      # routing.public

      # GET
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []

        targets = Repository::For.klass(Entity::Target).find_companys(session[:watching])

        session[:watching] = targets.map(&:company_name)

        flash.now[:notice] = 'Add a company to get started' if targets.none?

        viewable_targets = Views::TargetsList.new(targets)
        view 'home', locals: { targets: viewable_targets }
      end

      routing.on 'target' do
        routing.is do
          # POST /target/
          routing.post do
            company = routing.params['company_name'].downcase
            if COMPANY_LIST[0][company].nil?
              flash[:error] = 'Company not define in our search!'
              response.status = 400
              routing.redirect '/'
            end

            build_entity(company, routing)

            # Redirect viewer target page
            routing.redirect "target/#{company}"
          end
        end

        routing.on String do |company|
          # GET /target/company
          routing.get do
            # Get company from database
            target = Repository::For.klass(Entity::Target)
              .find_company(company)
            
              
            session[:watching].insert(0, company).uniq!
            view 'target', locals: { target: target }
          end
        end
      end

      routing.on 'history' do
        routing.is do
          # POST /history/
          routing.post do
            # Redirect viewer history page
            routing.redirect "history/#{company}"
          end
        end

        routing.on String do |company|
          # GET /history/company
          routing.get do
            # Get histories from database
            histories = Repository::Histories.find_company(company)

            viewable_histories = Views::HistoriesList.new(histories, company)
            view 'history', locals: { histories: viewable_histories }
          end
        end
      end
    end
    # check different condition of api usage: create/ update/ do nothing
    class TargetCheck
      attr_reader :status

      def initialize(company_name)
        @company_name = company_name
        @status = Repository::Targets.check_status(@company_name)
      end

      def api_find
        GoogleNews::TargetMapper
          .new(App.config.GOOGLENEWS_TOKEN)
          .find(@company_name, @status.search_from)
      end
    end

    def build_entity(company, routing)
      check = TargetCheck.new(company)
      return if check.status.up_to_date?
        begin
          target = check.api_find
        rescue StandardError
          flash[:error] = 'Could not get target from newsapi.'
          routing.redirect '/'
        end

        begin
          Repository::For.entity(target).create(target)
        rescue StandardError => e
          puts e.backtrace.join("\n")
          flash[:error] = 'Having trouble accessing the database'
        end
      
    end
  end
end
