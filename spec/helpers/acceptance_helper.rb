# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'

require 'headless'
require 'webdrivers/chromedriver'
require 'webdrivers'
require 'watir'
require 'page-object'
# require 'watir-webdriver'