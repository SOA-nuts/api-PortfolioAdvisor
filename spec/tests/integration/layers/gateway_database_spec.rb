# frozen_string_literal: false

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Integration Tests of GoogleNews API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news(recording: :none)
    VcrHelper.configure_vcr_for_yahoo_finance(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store target' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save target from GoogleNews to database' do
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(COMPANY_NAME, COMPANY_SYMBOL)

      rebuilt = PortfolioAdvisor::Repository::For.entity(target).create(target)

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