# frozen_string_literal: true

require 'http'
require 'yaml'
require_relative 'article'
require_relative 'publish'

# need to remove
TOPIC = 'business'
#START_DATE = '2021-10-01'
# END_DATE = '2021-10-12'
RESULT_NUM = 15
##

module NewsArticle
  # Library for Github Web API
  class GoogleNewsApi
    API_GOOGLE_NEWS_ROOT = 'https://newsapi.org/v2/everything?'

    module Errors
      class BadRequest < StandardError; end
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
    end

    HTTP_ERROR = {
      400 => Errors::BadRequest,
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token)
      @gn_token = token
    end

    def article(topic, result_num)
      article_req_url = gn_api_path(topic, result_num)
      article_data = call_gn_url(article_req_url).parse
      Article.new(article_data['articles'], self)
    end
    def publish(publish)
      Publish.new(publish)
    end 

    def testing(topic, result_num)
    # url = gn_api_path(topic, start_date, end_date ,result_num)
    # ans = call_gn_url(url).parse
    #  puts ans['articles']

        article = article(topic, result_num)
         puts article.time[0]
     end

    private

    def gn_api_path(topic, result_num)
      path = "q=#{topic}&from=2021-10-1&to=2021-10-15&pageSize=#{result_num}"
      "#{API_GOOGLE_NEWS_ROOT}#{path}"
    end

    def call_gn_url(url)
      result =
        HTTP.headers('Accept' => 'json',
                     'Authorization' => "token #{@gn_token}")
            .get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.status)
    end
  end
end

# this is for testing
# config = YAML.safe_load(File.read('../config/secrets.yml'))
#  GOOGLENEWS_TOKEN = config['GOOGLENEWS_TOKEN']
# NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
#                                       .testing(TOPIC, RESULT_NUM)
