# frozen_string_literal: true

require 'roda'
require 'yaml'
module PortfolioAdvisor
    # Configuration for the App
    class App < Roda
      CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
      GOOGLENEWS_TOKEN = CONFIG['GOOGLENEWS_TOKEN']
    end
  end