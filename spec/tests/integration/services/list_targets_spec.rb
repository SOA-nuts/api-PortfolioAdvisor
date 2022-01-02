# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'List Target Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news(recording: :none)
    VcrHelper.configure_vcr_for_yahoo_finance(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
    VcrHelper.eject_vcr
  end

  describe 'List Targets' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return targets that are being watched' do
      # GIVEN: a valid project exists locally and is being watched
      gn_target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(COMPANY_NAME, COMPANY_SYMBOL)

      db_target = PortfolioAdvisor::Repository::For.entity(gn_target)
        .create(gn_target)

      # WHEN: we request a list of all watched projects
      list_request = PortfolioAdvisor::Request::EncodedTargetList
        .to_request([COMPANY_NAME])

      result = PortfolioAdvisor::Service::ListTargets
        .new.call(list_request: list_request)

      # THEN: we should see our project in the resulting list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.targets).must_include db_target
    end

    it 'HAPPY: should not return targets that are not being watched' do
      # GIVEN: a valid target exists locally but is not being watched
      gn_target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(COMPANY_NAME, COMPANY_SYMBOL)
      PortfolioAdvisor::Repository::For.entity(gn_target)
        .create(gn_target)

      # WHEN: we request an empty list
      list_request = PortfolioAdvisor::Request::EncodedTargetList.to_request([])
      result = PortfolioAdvisor::Service::ListTargets.new.call(
        list_request: list_request
      )

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.targets).must_equal []
    end

    it 'SAD: should not watched targets if they are not loaded' do
      # GIVEN: we are watching a project that does not exist locally
      list_request = PortfolioAdvisor::Request::EncodedTargetList.to_request(
        [COMPANY_NAME]
      )

      # WHEN: we request a list of all watched targets
      result = PortfolioAdvisor::Service::ListTargets.new.call(
        list_request: list_request
      )

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      list = result.value!.message
      _(list.targets).must_equal []
    end
  end
end