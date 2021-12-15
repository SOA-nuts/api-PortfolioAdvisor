# frozen_string_literal: true

require 'http'
require 'yaml'
require 'date'

yahoo_token = 'IB9kqL92fA5gcp3uNb9vX7QXofZINt6q3zR4Fs8W'
# search for specific topic e.g: business, BBC ...
def yahoofinance_api_path(path)
    "https://query1.finance.yahoo.com/v11/finance/quoteSummary/#{path}"
end

def call_yahoo_url(token, url)
  HTTP.headers(
               'x-api-key' => token
               ).get(url)
end

yahoo_response = {}

# try some business request
yahoo_url = yahoofinance_api_path('AAPL?modules=financialData')
yahoo_response[yahoo_url] = call_yahoo_url(yahoo_token, yahoo_url)
report = yahoo_response[yahoo_url].parse

# report.each do |key, value|
#   puts "#{key}: #{value}"
# end

puts report['quoteSummary'][0]
# gn_results['articles'] = project['articles']
# File.write('apple_results.yml', gn_results.to_yaml)
