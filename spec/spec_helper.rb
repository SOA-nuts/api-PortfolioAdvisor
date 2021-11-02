# frozen_string_literal: true

# require 'simplecov'
# SimpleCov.start

# require 'minitest/autorun'
# require 'minitest/rg'
# require 'yaml'
# require 'vcr'
# require 'webmock'
# require 'date'
# require_relative '../init'



# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init'

TOPIC = 'apple'
RESULT_NUM = 15
GOOGLENEWS_TOKEN = PortfolioAdvisor::App.config.GOOGLENEWS_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/apple_results.yml'))
