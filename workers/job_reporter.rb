# frozen_string_literal: true

require_relative 'progress_publisher'

module NewsAdd
  # Reports job progress to client
  class JobReporter
    attr_accessor :company_name, :need_update, :symbol

    def initialize(request_json, config)
      search_request = PortfolioAdvisor::Representer::NewsRequest
        .new(OpenStruct.new)
        .from_json(request_json)

      @company_name = search_request.company_name
      @need_update = search_request.need_update
      @symbol = search_request.symbol
      @publisher = ProgressPublisher.new(config, search_request.id)
    end

    def report(msg)
      @publisher.publish msg
    end

    def report_each_second(seconds, &operation)
      seconds.times do
        sleep(1)
        report(operation.call)
      end
    end
  end
end
