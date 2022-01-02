# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../init'

COMPANY_NAME = 'apple'
COMPANY_SYMBOL = 'AAPL'
RESULT_NUM = 15
GOOGLENEWS_TOKEN = PortfolioAdvisor::App.config.GOOGLENEWS_TOKEN
YAHOO_TOKEN = PortfolioAdvisor::App.config.YAHOO_TOKEN
CORRECT_ARTICLE = YAML.safe_load(File.read('spec/fixtures/apple_results.yml'))
CORRECT_FINANCE = YAML.safe_load(File.read('spec/fixtures/AAPL_summary.yml'))
URL = 'https://www.wired.com/story/macbook-pro-ports-magsafe-design/'

# Helper method for acceptance tests
def homepage
  PortfolioAdvisor::App.config.APP_HOST
end
