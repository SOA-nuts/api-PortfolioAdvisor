# frozen_string_literal:true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

describe 'Integration Tests of GoogleNews API and the Crawler' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news
  end

  after do
    VcrHelper.eject_vcr
  end
  
  it 'BAD: should be bad request' do
    _(proc do
      PortfolioAdvisor::Crawler::Api
      .new("https://no.such.domain").crawl
    end).must_raise "NotFound"
  end
end
 



