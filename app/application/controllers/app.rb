# frozen_string_literal: true

require 'roda'
require 'slim'
require 'yaml'
require 'slim/include'

module PortfolioAdvisor
  # Web App
  class App < Roda

    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row_click.js'
    

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS
      # routing.public

      # GET
      routing.root do
        # Get cookie viewer's previously seen targets
        session[:watching] ||= []
        result = Service::ListTargets.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_targets = []
        else
          targets = result.value!
          if targets.none?
            flash.now[:notice] = 'Add a company to get started'
          end

          session[:watching] = targets.map(&:company_name)
          viewable_targets = Views::TargetsList.new(targets)
        end

        view 'home', locals: { targets: viewable_targets }
      end

      routing.on 'target' do
        routing.is do
          # POST /target/
          routing.post do
            target_request = Forms::NewTarget.new.call(routing.params)
            target_made = Service::AddTarget.new.call(target_request)

            if target_made.failure?
              flash[:error] = target_made.failure
              routing.redirect '/'
            end

            target = target_made.value!
            session[:watching].insert(0, target.company_name).uniq!
            #f lash[:notice] = 'target added to your list'
            # Redirect viewer target page
            routing.redirect "target/#{target.company_name}"

          end
        end

        routing.on String do |company|
          # GET /target/company
          routing.get do

            session[:watching] ||= []

            result = Service::ResultTarget.new.call(
              watched_list: session[:watching],
              requested: company
            )
            
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            result = result.value!
            view 'target', locals: { target: result[:target] }
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
            session[:watching] ||= []
            result = Service::ResultHistory.new.call(
              watched_list: session[:watching],
              requested: company
            )
            
            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            result = result.value!
            viewable_histories = Views::HistoriesList.new(result[:history], company)
            view 'history', locals: { histories: viewable_histories }
          end
        end
      end
    end
  end
end
