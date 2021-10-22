# frozen_string_literal: true

require 'http'
require 'yaml'
config = YAML.safe_load(File.read('../config/secrets.yml'))
# search for specific topic e.g: business, BBC ...
def gn_api_topic(topic)
  "https://newsapi.org/v2/everything?q=#{topic}&from=2021-10-1&to=2021-10-15"
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
project_url = gn_api_topic('business')
gn_response[project_url] = call_gn_url(config, project_url)
project = gn_response[project_url].parse

project['articles'].each do |article|
  articles << article
end
gn_results['articles'] = project['articles']
File.write('../spec/fixtures/business_results.yml', gn_results.to_yaml)

# test
# puts YAML.safe_load(File.read('../spec/fixtures/business_results.yml'))['articles'][0]['url']

## BAD project request- leave the topic blank
# bad_project_url = gn_api_topic('')
# gn_results[bad_project_url] = call_gn_url(config, bad_project_url)
# gn_results[bad_project_url].parse
