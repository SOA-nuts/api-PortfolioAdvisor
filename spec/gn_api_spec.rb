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
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end
  describe 'News title' do
    it 'HAPPY: should provide correct news article attributes' do
      article = NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
                                          .article(TOPIC, RESULT_NUM)
      _(article.url[0]).must_equal CORRECT['articles'][0]['url']
      _(article.title[0]).must_equal CORRECT['articles'][0]['title']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN).article('', 1)
      end).must_raise NewsArticle::GoogleNewsApi::Response::BadRequest
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        NewsArticle::GoogleNewsApi.new('BAD_TOKEN').article(TOPIC, 1)
      end).must_raise NewsArticle::GoogleNewsApi::Response::Unauthorized
    end
  end
  describe 'Test Published Date of News' do
    before do
      @publish = NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
                                           .article(TOPIC, RESULT_NUM).publish
    end
    it 'HAPPY: should provide correct publishing time' do
      _(@publish.time).wont_be_nil
      _(@publish.time[0]).must_equal CORRECT['articles'][0]['publishedAt'][-9...-1]
    end
    it 'HAPPY: should provide correct publishing dates' do
      _(@publish.date).wont_be_nil
      _(@publish.date[0]).must_equal CORRECT['articles'][0]['publishedAt'][0...10]
    end
  end
end
