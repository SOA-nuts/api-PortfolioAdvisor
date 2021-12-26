# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  PortfolioAdvisor::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_google_news
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Add targets route' do
    it 'should be able to add a target' do
      post "api/v1/target/#{COMPANY_NAME}"

      _(last_response.status).must_equal 201

      target = JSON.parse(last_response.body)

      _(target['company_name']).must_equal COMPANY_NAME
      _(target['articles'].count).must_equal 15

      proj = PortfolioAdvisor::Representer::Target.new(
        PortfolioAdvisor::Representer::OpenStructWithLinks.new
      ).from_json last_response.body

      _(proj.links['self'].href).must_include 'http'
    end

    it 'should report error for invalid targets' do
      post 'api/v1/target/BadCompanyName'

      _(last_response.status).must_equal 404

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'not'
    end

    it 'should be able to get a target' do
      PortfolioAdvisor::Service::AddTarget.new.call(company_name: COMPANY_NAME)
      get "api/v1/target/#{COMPANY_NAME}"

      _(last_response.status).must_equal 200

      target = JSON.parse last_response.body
      _(target['company_name']).must_equal COMPANY_NAME
      _(target['articles'].count).must_equal 15

      proj = PortfolioAdvisor::Representer::Target.new(
        PortfolioAdvisor::Representer::OpenStructWithLinks.new
      ).from_json last_response.body
      _(proj.links['self'].href).must_include 'http'
    end
  end

  describe 'Get targets list' do
    it 'should successfully return target lists' do
      PortfolioAdvisor::Service::AddTarget.new.call(company_name: COMPANY_NAME)

      list = [COMPANY_NAME.to_s]
      encoded_list = PortfolioAdvisor::Request::EncodedTargetList.to_encoded(list)

      get "/api/v1/target?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      targets = response['targets']
      _(targets.count).must_equal 1
      target = targets.first
      _(target['company_name']).must_equal COMPANY_NAME
      _(target['market_price']).must_equal CORRECT_FINANCE['financialData']['currentPrice']['raw']
      # first record should be the newest
      _(target['updated_at']).must_equal Date.today.strftime('%Y-%m-%d')
    end

    it 'should return empty lists if not found' do
      list = ['BadCompanyName']
      encoded_list = PortfolioAdvisor::Request::EncodedTargetList.to_encoded(list)

      get "/api/v1/target?list=#{encoded_list}"
      _(last_response.status).must_equal 200
      response = JSON.parse(last_response.body)
      targets = response['targets']
      _(targets).must_be_kind_of Array
      _(targets.count).must_equal 0
    end

    it 'should return error if no list provided' do
      get '/api/v1/target'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end

  describe 'get histories list' do
    it 'should successfully return histories list' do
      PortfolioAdvisor::Service::AddTarget.new.call(company_name: COMPANY_NAME)

      get "/api/v1/history/#{COMPANY_NAME}"
      _(last_response.status).must_equal 200
      response = JSON.parse(last_response.body)
      histories = response['histories']
      _(histories.count).must_equal 1
      history = histories.first
      # first record should be the latest
      _(history['updated_at']).must_equal Date.today.strftime('%Y-%m-%d')
    end

    it 'should return empty histories list if not found' do
      get '/api/v1/history/BadCompanyName'

      _(last_response.status).must_equal 500
      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'trouble'
    end
  end
end
