# frozen_string_literal: true

require 'roda'

module PortfolioAdvisor
  # Web App
  class App < Roda
    plugin :halt
    plugin :caching
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      response['Content-Type'] = 'application/json'

      # GET
      routing.root do
        message = "PortfolioAdvisor API v1 at /api/v1/ in #{App.environment} mode"
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'target' do
          routing.on String do |company|
            # GET /target/{company_name}
            routing.get do
              response.cache_control public: true, max_age: 60
              
              path_request = Request::TargetPath.new(
                company, request
              )

              result = Service::ResultTarget.new.call(requested: path_request)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::Target.new(result.value!.message).to_json
            end

            # POST /target/{company_name}
            routing.post do
              result = Service::AddTarget.new.call(company_name: company)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::Target.new(result.value!.message).to_json
            end
          end

          routing.is do
            # GET /target?list={base64_json_array_of_company_names}
            routing.get do
              list_req = Request::EncodedTargetList.new(routing.params)
              result = Service::ListTargets.new.call(list_request: list_req)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::TargetsList.new(result.value!.message).to_json
            end
          end
        end

        routing.on 'history' do
          routing.on String do |company|
            # GET /history/{company_name}
            routing.get do
              path_request = Request::HistoryPath.new(
                company, request
              )
              result = Service::ResultHistory.new.call(requested: path_request)
              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::HistoriesList.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
