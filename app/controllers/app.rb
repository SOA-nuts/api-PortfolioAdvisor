# frozen_string_literal: true

require 'roda'
require 'slim'
require 'yaml'
require 'slim/include'

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
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS
      routing.public

      # GET 
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []
        
        #targets = Repository::For.klass(Entity::Target).all
        targets = Repository::For.klass(Entity::Target).find_companys(session[:watching])

        session[:watching] = targets.map(&:company_name)

        if targets.none?
          flash.now[:notice] = 'Add a company to get started'
        end

        view 'home', locals: { targets: targets }
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

            #routing.halt 400 if COMPANY_LIST[0][company].nil?

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

            view 'target', locals: { target: target}
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
            view 'history', locals: {histories: histories, company: company}
          end
        end  
      end
    end

    def build_entity(company)

      company_record = Repository::Targets.find_company(company)

      if company_record.nil?
        begin
          target = GoogleNews::TargetMapper
          .new(App.config.GOOGLENEWS_TOKEN)
          .find(company, nil)
        rescue StandardError
          flash[:error] = 'Could not get target from newsapi.'
          routing.redirect '/'
        end

        begin
          Repository::For.entity(target).create(target)
          rescue StandardError => err
            puts err.backtrace.join("\n")
            flash[:error] = 'Having trouble accessing the database'       
        end

        session[:watching].insert(0, target.company_name).uniq!

      elsif company_record.updated_at != Date.today
        begin
          target = GoogleNews::TargetMapper
          .new(App.config.GOOGLENEWS_TOKEN)
          .find(company, company_record.updated_at)
        rescue StandardError
          flash[:error] = 'Could not get target from newsApi.'
          routing.redirect '/'
        end

        begin
          Repository::For.entity(target).update(target)
          rescue StandardError => err
            puts err.backtrace.join("\n")
            flash[:error] = 'Having trouble accessing the database'
        end

        session[:watching].insert(0, company_record.company_name).uniq!
      end
    end
  end
end