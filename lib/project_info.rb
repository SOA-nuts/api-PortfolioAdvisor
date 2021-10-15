# frozen_string_literal: true

require 'news-api'
require 'yaml'
config = YAML.safe_load(File.read('../config/secrets.yml'))
@newsapi = News.new(config['GOOGLENEWS_TOKEN'])

def gn_api_topic(topic)
  @newsapi.get_everything(q: topic,
                          sources: 'bbc-news,the-verge',
                          domains: 'bbc.co.uk,techcrunch.com',
                          language: 'en',
                          sortBy: 'relevancy',
                          pageSize: 2)
end

# GOOD project request
all_articles = gn_api_topic('business')

# BAD project request- leave the topic blank
gn_api_topic('')

File.write('../spec/fixtures/business_results.yml', all_articles.to_yaml)

# try other googleNews_api

# # /v2/top-headlines
# top_headlines = newsapi.get_top_headlines(q: 'business',
#                                           sources: 'bbc-news,the-verge',
#                                           language: 'en',
#                                           )

# # /v2/top-headlines/sources
# sources = newsapi.get_sources(country: 'us', language: 'en')
