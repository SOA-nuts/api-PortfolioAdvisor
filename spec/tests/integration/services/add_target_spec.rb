# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Add Target Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news(recording: :none)
    VcrHelper.configure_vcr_for_yahoo_finance(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save target from GoogleNews to database' do
      # GIVEN: a valid company name request for a company in the serving list:
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(COMPANY_NAME, COMPANY_SYMBOL)

      # WHEN: the service is called with the request form object
      target_made = PortfolioAdvisor::Service::AddTarget.new.call(
        company_name: COMPANY_NAME
      )

      # THEN: the result should report success..
      if target_made.failure?
        puts target_made.failure
      end
      _(target_made.success?).must_equal true

      # ..and provide a target entity with the right details
      rebuilt = target_made.value!.message

      _(rebuilt.company_name).must_equal(target.company_name)
      _(rebuilt.updated_at).must_equal(target.updated_at)
      _(rebuilt.market_price).must_equal(target.market_price)
      _(rebuilt.long_advice_price).must_equal(target.long_advice_price)
      _(rebuilt.mid_advice_price).must_equal(target.mid_advice_price)
      _(rebuilt.short_advice_price).must_equal(target.short_advice_price)
      _(rebuilt.articles.count).must_equal(target.articles.count)

      target.articles.each do |article|
        found = rebuilt.articles.find do |potential|
          potential.url == article.url
        end

        _(found.title).must_equal article.title
        _(found.score).must_equal article.score
      end
    end

    it 'HAPPY: should find and return existing target in database' do
      # GIVEN: a valid url request for a project already in the database:
      db_target = PortfolioAdvisor::Service::AddTarget.new.call(
        company_name: COMPANY_NAME
      ).value!.message

      # WHEN: the service is called with the request form object
      target_made = PortfolioAdvisor::Service::AddTarget.new.call(
        company_name: COMPANY_NAME
      )

      # THEN: the result should report success..
      _(target_made.success?).must_equal true

      # ..and find the same target that was already in the database
      rebuilt = target_made.value!.message
      _(rebuilt.id).must_equal(db_target.id)

      # ..and provide a target entity with the right details
      _(rebuilt.company_name).must_equal(db_target.company_name)
      _(rebuilt.updated_at).must_equal(db_target.updated_at)
      _(rebuilt.market_price).must_equal(db_target.market_price)
      _(rebuilt.long_advice_price).must_equal(db_target.long_advice_price)
      _(rebuilt.mid_advice_price).must_equal(db_target.mid_advice_price)
      _(rebuilt.short_advice_price).must_equal(db_target.short_advice_price)
      _(rebuilt.articles.count).must_equal(db_target.articles.count)

      db_target.articles.each do |article|
        found = rebuilt.articles.find do |potential|
          potential.url == article.url
        end

        _(found.title).must_equal article.title
        _(found.score).must_equal article.score
      end
    end

    it 'SAD: should gracefully fail for non-existent taregt details' do
      # WHEN: the service is called with non-existent target details
      target_made = PortfolioAdvisor::Service::AddTarget.new.call(
        company_name: 'bad_company_name'
      )

      # THEN: the service should report failure with an error message
      _(target_made.success?).must_equal false
      _(target_made.failure.message.downcase).must_include 'not find'
    end
  end
end