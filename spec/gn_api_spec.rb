# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/google_news_api'

TOPIC = 'business'
# START_DATE = '2021-10-01'
# END_DATE = '2021-10-15'
RESULT_NUM = 15
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
GOOGLENEWS_TOKEN = CONFIG['GOOGLENEWS_TOKEN']
CORRECT = YAML.safe_load(File.read('../spec/fixtures/business_results.yml'))

describe 'Tests Google News API library' do
  describe 'News title' do
    it 'HAPPY: should provide correct news article attributes' do
      article = NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
                                          .article(TOPIC, RESULT_NUM)
      puts article
      _(article.url[0]).must_equal CORRECT['articles'][0]['url']
      _(article.title[0]).must_equal CORRECT['articles'][0]['title']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
        NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN).article('', 1)
      end).must_raise NewsArticle::GoogleNewsApi::Errors::BadRequest
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        NewsArticle::GoogleNewsApi.new('BAD_TOKEN').article(TOPIC, 1)
      end).must_raise NewsArticle::GoogleNewsApi::Errors::Unauthorized
    end
  end

  describe 'Test Published Date of News' do
    before do
      @time = NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
                                         .article(TOPIC, RESULT_NUM).time
      @date = NewsArticle::GoogleNewsApi.new(GOOGLENEWS_TOKEN)
                                          .article(TOPIC, RESULT_NUM).date  
    end

    it 'HAPPY: should provide correct publishing dates' do
      _(@time).wont_be_nil
      _(@time[0]).must_equal CORRECT['articles'][0]['publishedAt'][-9...-1]
    end
 end

end
