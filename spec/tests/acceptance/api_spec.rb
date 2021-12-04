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
      post "api/v1/target/#{TOPIC}"

      _(last_response.status).must_equal 201

      target = JSON.parse(last_response.body)

      _(target['company_name']).must_equal TOPIC
      _(target['articles'].count).must_equal 15

      proj = PortfolioAdvisor::Representer::Target.new(
        PortfolioAdvisor::Representer::OpenStructWithLinks.new
      ).from_json last_response.body

      _(proj.links['self'].href).must_include 'http'
    end

    it 'should report error for invalid targets' do
      post 'api/v1/target/0u9awfh4'

      _(last_response.status).must_equal 404
      
      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'not'
    end

    it 'should be able to get a target' do
      PortfolioAdvisor::Service::AddTarget.new.call(company_name: TOPIC)
      get "api/v1/target/#{TOPIC}"

      _(last_response.status).must_equal 200

      target = JSON.parse last_response.body
      _(target['company_name']).must_equal TOPIC
      _(target['articles'].count).must_equal 15

      proj = PortfolioAdvisor::Representer::Target.new(
        PortfolioAdvisor::Representer::OpenStructWithLinks.new
      ).from_json last_response.body
      _(proj.links['self'].href).must_include 'http'
    end
  end

  describe 'Get targets list' do
    it 'should successfully return target lists' do
      PortfolioAdvisor::Service::AddTarget.new.call(company_name: TOPIC)

      list = ["#{TOPIC}"]
      encoded_list = PortfolioAdvisor::Request::EncodedTargetList.to_encoded(list)

      get "/api/v1/target?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      targets = response['targets']
      _(targets.count).must_equal 1
      target = targets.first
      _(target['company_name']).must_equal TOPIC
      _(target['score']).must_equal 2
      # vcr record at "2021-12-04"
      _(target['updated_at']).must_equal "2021-12-04"
    end

    it 'should return empty lists if none found' do
      list = ['djsafildafs;d']
      encoded_list = PortfolioAdvisor::Request::EncodedTargetList.to_encoded(list)

      get "/api/v1/target?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      targets = response['targets']
      _(targets).must_be_kind_of Array
      _(targets.count).must_equal 0
    end

    it 'should return error if not list provided' do
      get '/api/v1/target'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end

  describe 'get histories list' do
    it 'should successfully return histories list' do
      PortfolioAdvisor::Service::AddTarget.new.call(company_name: TOPIC)


      get "/api/v1/history/#{TOPIC}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      histories = response['histories']
      _(histories.count).must_equal 1
      history = histories.first
      _(history['score']).must_equal 2
      # vcr record at "2021-12-04"
      _(history['updated_at']).must_equal "2021-12-04"
    end
  end

  it 'should return empty histories list if none found' do
    get "/api/v1/history/WTFFFFEMMM"

    _(last_response.status).must_equal 500

    response = JSON.parse(last_response.body)
    histories = response['histories']
    _(histories).must_be_kind_of Array
    _(histories.count).must_equal 0
  end

  it 'should return error if not list provided' do
    get '/api/v1/history'
    _(last_response.status).must_equal 404

    puts last_response
    response = JSON.parse(last_response.body)
    _(response['message']).must_include 'list'
  end
end
