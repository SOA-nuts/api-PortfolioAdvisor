# frozen_string_literal: true

require 'http'
require 'yaml'
require 'date'

token = "BvQRfydrJt3QIQl_8WYvXkuTtdPRRlxn"
# search for specific topic e.g: business, BBC ...
def polygon_api_path(path)
  "https://api.polygon.io/v1/open-close/#{path}"
#   "https://api.polygon.io/v1/open-close/#{symbol}/2020-10-14?adjusted=true&apiKey=BvQRfydrJt3QIQl_8WYvXkuTtdPRRlxn"

end

def call_gn_url(token, url)
    puts url
    puts "#{token}"
    HTTP.headers('Accept' => 'json',
        'Authorization' => "apiKey #{token}").get(url)
end

polygon_response = {}
polygon_results = {}

# try some business request
project_url = polygon_api_path("AAPL/2020-10-14?adjusted=true")
polygon_response[project_url] = call_gn_url(token, project_url)
project = polygon_response[project_url].parse

project.each do |key, value|
  puts "#{key}: #{value}"
end
