# frozen_string_literal: true
# require 'http'
require 'news-api'
require 'yaml'
config = YAML.safe_load(File.read('../config/secrets.yml'))
# API_GOOGLE_NEWS_ROOT = 'https://newsapi.org/v2/top-headlines?'
@newsapi = News.new(config['GOOGLENEWS_TOKEN'])
@gn_token = config['GOOGLENEWS_TOKEN']
def gn_api_topic(topic, result_num)
  @newsapi.get_top_headlines(q: topic,
                             category: topic,
                             from: '2021-10-01',
                             to: '2021-10-12',
                             language: 'en',
                             sortBy: 'relevancy',
                             pageSize: result_num)

  # path = "category=" + topic+'&from=2021-10-01'+"&to=2021-10-12"+"&language=en&sortBy=relevancy&pageSize="+result_num.to_s
  # url = "#{API_GOOGLE_NEWS_ROOT}#{path}"
  # result =
  # HTTP.headers('Accept' => 'json',
  #             'Authorization' => "token #{@gn_token}")
  #     .get(url)
end

# GOOD news article request
all_articles = gn_api_topic('business', 15)
puts all_articles.parse

# BAD news article request- leave the topic blank
gn_api_topic('', 15)

File.write('../spec/fixtures/business_results.yml', all_articles.to_yaml)
