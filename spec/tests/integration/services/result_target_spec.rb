# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'AppraiseProject Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Show Target Result' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should give score of articles related to the target' do
      # GIVEN: a valid project that exists locally
      gn_target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC, nil)
      PortfolioAdvisor::Repository::For.entity(gn_target).create(gn_target)

      # WHEN: we request to analyze the target
      request = OpenStruct.new(
        company_name: TOPIC
      )

      result = PortfolioAdvisor::Service::ResultTarget.new.call(
        requested: request
      ).value!.message

      # THEN: we should get an analized result
      _(result.company_name).must_equal TOPIC
      _(result.articles.count).must_equal 15
    end

    it 'SAD: should not give analize for non-existent target' do
      # GIVEN: no target exists locally

      # WHEN: we request to analyze the target
      request = OpenStruct.new(
        company_name: TOPIC
      )

      result = PortfolioAdvisor::Service::ResultTarget.new.call(
        requested: request
      )

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end
  end
end