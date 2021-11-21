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

TOPIC = 'apple'
RESULT_NUM = 15
GOOGLENEWS_TOKEN = PortfolioAdvisor::App.config.GOOGLENEWS_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/apple_results.yml'))
URL = 'https://www.wired.com/story/macbook-pro-ports-magsafe-design/'

# Helper method for acceptance tests
def homepage
  PortfolioAdvisor::App.config.APP_HOST
end
