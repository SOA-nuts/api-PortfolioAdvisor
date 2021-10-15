# frozen_string_literal: true

require 'news-api'
require 'yaml'
config = YAML.safe_load(File.read('../config/secrets.yml'))
@newsapi = News.new(config['GOOGLENEWS_TOKEN'])

def gn_api_topic(topic, result_num)
  @newsapi.get_top_headlines(q: topic,
                             category: topic,
                             from: '2021-10-01',
                             to: '2021-10-12',
                             language: 'en',
                             sortBy: 'relevancy',
                             pageSize: result_num)
end

# GOOD project request
all_articles = gn_api_topic('business', 15)

# BAD project request- leave the topic blank
gn_api_topic('', 15)

File.write('../spec/fixtures/business_results.yml', all_articles.to_yaml)
