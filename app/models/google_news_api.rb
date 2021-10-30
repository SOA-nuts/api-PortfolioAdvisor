# frozen_string_literal: true

require 'http'
require 'delegate'
require_relative 'article'

module NewsArticle
  # Library for Github Web API
  class GoogleNewsApi
    API_GOOGLE_NEWS_ROOT = 'https://newsapi.org/v2/everything?'

    def initialize(token)
      @gh_token = token
    end

    def article(topic, result_num)
      article_data = Request.new(API_GOOGLE_NEWS_ROOT, @gh_token)
                            .news(topic, result_num).parse
      Article.new(article_data['articles'], self)
    end

    # Sends out HTTP requests to Github
    class Request
      def initialize(resource_root, token)
        @resource_root = resource_root
        @token = token
      end

      def news(topic, result_num)
        path = "q=#{topic}&from=2021-10-1&to=2021-10-15&pageSize=#{result_num}"
        get(@resource_root + path)
      end

      def get(url)
        http_response = HTTP.headers(
          'Accept' => 'application/vnd.github.v3+json',
          'Authorization' => "token #{@token}"
        ).get(url)

        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end
    end

    # Decorates HTTP responses from Github with success/error reporting
    class Response < SimpleDelegator
      # :reek:IrresponsibleModule
      BadRequest = Class.new(StandardError)
      # :reek:IrresponsibleModule
      Unauthorized = Class.new(StandardError)
      # :reek:IrresponsibleModule~
      NotFound = Class.new(StandardError)

      HTTP_ERROR = {
        400 => BadRequest,
        401 => Unauthorized,
        404 => NotFound
      }.freeze

      def successful?
        !HTTP_ERROR.keys.include?(code)
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
