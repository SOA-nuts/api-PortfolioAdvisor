# frozen_string_literal:true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

describe 'Tests Google News API library' do
  before do
    VcrHelper.configure_vcr_for_github
  end

  after do
    VcrHelper.eject_vcr
  end
  
  describe 'News title' do
    it 'HAPPY: should provide correct news article attributes' do
      target = PortfolioAdvisor::GoogleNews::TargetMapper
               .new(GOOGLENEWS_TOKEN)
               .find(TOPIC)
      _(target.company_name).must_equal TOPIC
      _(target.articles[0].title).must_equal CORRECT['articles'][0]['title']
      _(target.articles[0].url).must_equal CORRECT['articles'][0]['url']
    end

    it 'SAD: should raise exception on incorrect project' do
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
  describe 'Test Published Date of News' do
    before do
      @publish = PortfolioAdvisor::GoogleNews::TargetMapper
                 .new(GOOGLENEWS_TOKEN)
                 .find(TOPIC)
                 .articles[0].published_at
    end
    it 'HAPPY: should provide correct publishing time' do
      _(@publish.time).wont_be_nil
      _(@publish.time).must_equal CORRECT['articles'][0]['publishedAt'][-9...-1]
    end
    it 'HAPPY: should provide correct publishing dates' do
      _(@publish.date).wont_be_nil
      _(@publish.date).must_equal CORRECT['articles'][0]['publishedAt'][0...10]
    end
  end
end
