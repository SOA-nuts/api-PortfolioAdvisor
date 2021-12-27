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
yahoo_results = {}

# try some business request
yahoo_url = yahoofinance_api_path('AAPL?modules=financialData')
yahoo_response[yahoo_url] = call_yahoo_url(yahoo_token, yahoo_url)
report = yahoo_response[yahoo_url].parse

yahoo_results['financialData'] = report['quoteSummary']['result'][0]['financialData']
File.write('AAPL_summary.yml', yahoo_results.to_yaml)
