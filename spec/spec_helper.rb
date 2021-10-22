# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'
require 'date'
require_relative '../lib/google_news_api'

TOPIC = 'business'
RESULT_NUM = 15
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
GOOGLENEWS_TOKEN = CONFIG['GOOGLENEWS_TOKEN']
CORRECT = YAML.safe_load(File.read('../spec/fixtures/business_results.yml'))

CASSETTES_FOLDER = 'fixtures/cassettes'
CASSETTE_FILE = 'google_news_api'
