# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'

require 'headless'
require 'webdrivers/chromedriver'
require 'webdrivers'
require 'watir'
# require 'watir-webdriver'

describe 'Acceptance Tests' do
  before do
    DatabaseHelper.wipe_database
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @browser = Watir::Browser.new :chrome, options: options
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Homepage' do
    describe 'Visit Home page' do
      it '(HAPPY) should not see histories if none created' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # THEN: user should see basic headers, no projects and a welcome message
        _(@browser.h1(id: 'main_header').text).must_equal 'PortfolioAdvisor'
        _(@browser.text_field(id: 'url_input').present?).must_equal true
        _(@browser.button(id: 'company-form-submit').present?).must_equal true
        _(@browser.table(id: 'histories_table').exists?).must_equal false

        _(@browser.div(id: 'flash_bar_success').present?).must_equal true
        _(@browser.div(id: 'flash_bar_success').text.downcase).must_include 'start'
      end

      it '(HAPPY) should not see histories they did not request' do
        # GIVEN: a project exists in the database but GoogleNews has not requested it
        target = PortfolioAdvisor::GoogleNews::TargetMapper
          .new(GOOGLENEWS_TOKEN)
          .find(TOPIC, Date.today)
        PortfolioAdvisor::Repository::For.entity(target).create(target)

        # WHEN: user goes to the homepage
        @browser.goto homepage

        # THEN: they should not see any projects
        _(@browser.table(id: 'histories_table').exists?).must_equal false
      end
    end

    describe 'Add History' do
      it '(HAPPY) should be able to request a company' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # WHEN: they add a project URL and submit
        good_target = TOPIC
        @browser.text_field(id: 'url_input').set(good_target)
        @browser.button(id: 'company-form-submit').click

        # THEN: they should find themselves on the project's page
        @browser.url.include? TOPIC
      end

      it '(BAD) should not be able to add an invalid company name' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # WHEN: they request a project with an invalid URL
        bad_url = 'foobar'
        @browser.text_field(id: 'url_input').set(bad_url)
        @browser.button(id: 'company-form-submit').click

        # THEN: they should see a warning message
        _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
        _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'not define'
      end
    end
  end

  describe 'Target Page' do
    it '(HAPPY) should see project content if project exists' do
      # GIVEN: a project exists
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC, Date.today)

      PortfolioAdvisor::Repository::For.entity(target).create(target)

      # WHEN: user goes directly to the project page
      @browser.goto "http://localhost:9000/target/#{TOPIC}"

      # THEN: they should see the project details
      _(@browser.h2.text).must_include TOPIC

      article_columns = @browser.table(id: 'score_table').thead.ths

      _(article_columns.count).must_equal 2
    end
  end

  describe 'History Page' do
    it '(HAPPY) should see history content if history exists' do
      # GIVEN: a project exists
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC, Date.today)

      PortfolioAdvisor::Repository::For.entity(target).create(target)

      # WHEN: user goes directly to the project page
      @browser.goto "http://localhost:9000/history/#{TOPIC}"

      # THEN: they should see the project details
      _(@browser.h2.text).must_include TOPIC

      article_columns = @browser.table(id: 'history_table').thead.ths

      _(article_columns.count).must_equal 2
    end
  end
end
