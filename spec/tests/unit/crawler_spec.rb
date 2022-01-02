# frozen_string_literal:true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Unit Tests of the Crawler' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Try to crwal' do
    it 'BAD: should be bad request' do
      _(proc do
        PortfolioAdvisor::Crawler::Api
        .new('https://no.such.domain').crawl
      end).must_raise 'NotFound'
    end
  end
end
