# frozen_string_literal:true

require_relative 'spec_helper'

describe 'Tests Google News API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<SAFE_STRINGS>') { GOOGLENEWS_TOKEN }
    c.filter_sensitive_data('<SAFE_STRINGS_ESC>') { CGI.escape(GOOGLENEWS_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: [:method, :headers, VCR.request_matchers.uri_without_param(:from, :to)]

    #                     match_requests_on: %i[method uri headers]
    # VCR.request_matchers.uri_without_param(:from, :to)
  end

  after do
    VCR.eject_cassette
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
