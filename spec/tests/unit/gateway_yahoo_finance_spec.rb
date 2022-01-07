# frozen_string_literal:true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Yahoo Finance API library' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_yahoo_finance
  end

  after do
    VcrHelper.eject_vcr
  end

  def get_date(timestamp)
    DateTime.strptime(timestamp, '%Y-%m-%dT%H:%M:%S%z')
  end

  describe 'Finance info' do
    it 'HAPPY: should provide correct symbol' do
      summary = PortfolioAdvisor::YahooFinance::FinanceMapper
        .new(YAHOO_TOKEN)
        .find(COMPANY_SYMBOL)
      _(summary.bench_price).must_equal CORRECT_FINANCE['financialData']['targetMedianPrice']['raw']
      _(summary.market_price).must_equal CORRECT_FINANCE['financialData']['currentPrice']['raw']
      _(summary.grow_score).must_equal CORRECT_FINANCE['financialData']['revenueGrowth']['raw']
    end

    it 'SAD: should raise exception on incorrect target' do
      _(proc do
        PortfolioAdvisor::YahooFinance::FinanceMapper
        .new(YAHOO_TOKEN)
        .find('')
      end).must_raise PortfolioAdvisor::YahooFinance::Api::Response::NotFound
    end
  end
end
