# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  GOOGLENEWS_CASSETTE = 'google_news_api'
  YAHOO_CASSETTE = 'yahoo_finance_api'

  def self.setup_vcr
    VCR.configure do |vcr_config|
      vcr_config.cassette_library_dir = CASSETTES_FOLDER
      vcr_config.hook_into :webmock
      vcr_config.ignore_localhost = true # for acceptance tests
    end
  end

  def self.configure_vcr_for_google_news(recording: :new_episodes)
    VCR.configure do |config|
      config.filter_sensitive_data('<GOOGLENEWS_TOKEN>') { GOOGLENEWS_TOKEN }
      config.filter_sensitive_data('<GITHUB_TOKEN_GOOGLENEWS_TOKEN_ESCESC>') { CGI.escape(GOOGLENEWS_TOKEN) }
    end

    VCR.insert_cassette(
      GOOGLENEWS_CASSETTE,
      record: recording,
      match_requests_on: [:method, :headers, VCR.request_matchers.uri_without_param(:from, :to, :pageSize)],
      allow_playback_repeats: true
    )
  end

  def self.configure_vcr_for_yahoo_finance(recording: :new_episodes)
    VCR.configure do |config|
      config.filter_sensitive_data('<YAHOO_TOKEN>') { YAHOO_TOKEN }
      config.filter_sensitive_data('<GITHUB_TOKEN_YAHOO_TOKEN_ESCESC>') { CGI.escape(YAHOO_TOKEN) }
    end

    VCR.insert_cassette(
      YAHOO_CASSETTE,
      record: recording,
      match_requests_on: %i[method uri headers],
      allow_playback_repeats: true
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
