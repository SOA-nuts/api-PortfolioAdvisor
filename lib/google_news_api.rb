# frozen_string_literal: true

require 'http'
require 'yaml'
require 'news-api'
require_relative 'article'
require_relative 'publish'

API_GOOGLE_NEWS_ROOT = 'https://newsapi.org/v2/top-headlines?'

#need to remove
# TOPIC = 'business'
# START_DATE = '2021-10-01'
# END_DATE = '2021-10-12'
# RESULT_NUM = 15
##

module NewsArticle
    # Library for Github Web API
    class GoogleNewsApi
        module Errors
            class NotFound < StandardError; end
            class Unauthorized < StandardError; end # rubocop:disable Layout/EmptyLineBetweenDefs
        end

        HTTP_ERROR = {
        401 => Errors::Unauthorized,
        404 => Errors::NotFound
        }.freeze

        def initialize(token)
            @gn_token = token
        end

        def article(topic, start_date, end_date ,result_num)
            article_req_url = gn_api_path(topic, start_date, end_date ,result_num)
            article_data = call_gn_url(article_req_url).parse
            Article.new(article_data['articles'], self)
        end

        def testing(topic, start_date, end_date ,result_num)
            # url = gn_api_path(topic, start_date, end_date ,result_num)
            # ans = call_gn_url(url).parse
            # puts ans['articles']

            article = article(topic, start_date, end_date ,result_num)
            puts article.test
        end

        private

        def gn_api_path(topic, start_date, end_date ,result_num)
            path = "category=" + topic+'&from='+start_date+"&to="+end_date+"&language=en&sortBy=relevancy&pageSize="+result_num.to_s
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

#this is for testing
# config = YAML.safe_load(File.read('../config/secrets.yml'))
# GOOGLENEWS_TOKEN = config['GOOGLENEWS_TOKEN']
# NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
#                                      .testing(TOPIC, START_DATE, END_DATE, RESULT_NUM)