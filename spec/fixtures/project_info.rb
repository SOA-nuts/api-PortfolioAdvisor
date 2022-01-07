# frozen_string_literal: true

require 'http'
require 'yaml'
require 'date'

config = YAML.safe_load(File.read('../../config/secrets.yml'))
# search for specific topic e.g: business, BBC ...
def gn_api_topic(topic)
  "https://newsapi.org/v2/everything?q=#{topic}&from=2021-12-21&to=2021-12-21&pageSize=15&language=en"
end

def call_gn_url(config, url)
  page_size = 10
  url += "&pageSize=#{page_size}"
  HTTP.headers(
    'x-api-key' => config['GOOGLENEWS_TOKEN']
  ).get(url)
end

gn_response = {}
gn_results = {}
articles = []

# try some business request
project_url = gn_api_topic('apple')
gn_response[project_url] = call_gn_url(config, project_url)
project = gn_response[project_url].parse

project['articles'].each do |article|
  articles << article
end
gn_results['articles'] = project['articles']
File.write('apple_results.yml', gn_results.to_yaml)
