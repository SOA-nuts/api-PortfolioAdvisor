# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of GoogleNews API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_github
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store target' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save target from PortfolioAdvisor to database' do
        target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC)

      rebuilt = PortfolioAdvisor::Repository::For.entity(target).create(target)

      _(rebuilt.company_name).must_equal(target.company_name)
      _(rebuilt.articles.count).must_equal(target.articles.count)

      target.articles.each do |article|
        found = rebuilt.articles.find do |potential|
          potential.title == article.title
        end

        _(found.url).must_equal article.username
      end
    end
  end
end
