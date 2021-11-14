# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of GoogleNews API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store target' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save target from GoogleNews to database' do
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC)

      rebuilt = PortfolioAdvisor::Repository::For.entity(target).create(target)

      target.articles.each do |article|
        puts article.title
      end

      rebuilt.articles.each do |article|
        puts article.title
      end

      _(rebuilt.company_name).must_equal(target.company_name)
      _(rebuilt.articles.count).must_equal(target.articles.count)

      target.articles.each do |article|
        found = rebuilt.articles.find do |potential|
          potential.title == article.title
        end

        _(found.title).must_equal article.title
      end
    end
  end
end
