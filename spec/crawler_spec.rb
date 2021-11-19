require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
URL='https://www.reuters.com/business/finance/bitcoin-edges-off-all-time-high-momentum-more-gains-this-year-seen-intact-2021-10-21/'
describe 'Integration Tests of GoogleNews API and the Crawler' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news
  end

  after do
    VcrHelper.eject_vcr
  end

    it 'HAPPY: should be correct URL' do
      web_url = PortfolioAdvisor::Crawler::Api
        .new(URL)
      _(web_url.url).must_equal CORRECT['url']      
     end

it 'SAD: should raise exception when ' do
      _(proc do
        PortfolioAdvisor::Crawler::Api
        .new('BAD_URL')
      end).must_raise PortfolioAdvisor::GoogleNews::Api::Response::Unauthorized
    end
    end
 



