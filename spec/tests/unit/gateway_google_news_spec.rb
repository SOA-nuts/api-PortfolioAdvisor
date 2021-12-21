# frozen_string_literal:true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require 'date'

describe 'Tests Google News API library' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_google_news
  end

  after do
    VcrHelper.eject_vcr
  end

  def get_date(timestamp)
    DateTime.strptime(timestamp, '%Y-%m-%dT%H:%M:%S%z')
  end

  describe 'Target info' do
    it 'HAPPY: should provide correct target attributes' do
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC)
      _(target.company_name).must_equal TOPIC
      _(target.articles.length).must_equal CORRECT['articles'].length
    end

    it 'SAD: should raise exception on incorrect target' do
      _(proc do
        PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find('')
      end).must_raise PortfolioAdvisor::GoogleNews::Api::Response::BadRequest
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        PortfolioAdvisor::GoogleNews::TargetMapper
        .new('BAD_TOKEN')
        .find(TOPIC)
      end).must_raise PortfolioAdvisor::GoogleNews::Api::Response::Unauthorized
    end
  end

  describe 'article information' do
    before do
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC)
      @article = target.articles[0]
    end
    it 'HAPPY: should provide correct title' do
      _(@article.title).wont_be_nil
      _(@article.title).must_equal CORRECT['articles'][0]['title']
    end
    it 'HAPPY: should provide correct publish dates' do
      _(@article.published_at).wont_be_nil
      _(@article.published_at).must_equal get_date(CORRECT['articles'][0]['publishedAt'])
    end
  end
end
