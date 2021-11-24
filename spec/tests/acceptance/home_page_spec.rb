# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'

require 'headless'
require 'webdrivers'
#require 'webdrivers/chromedriver'
require 'watir'
require 'page-object'
#require 'chromedriver-helper'



#require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'
describe 'Home Page Acceptance Tests' do
    include PageObject::PageFactory
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
        # WHEN: they visit the home page
        visit HomePage do |page|

        # THEN: user should see basic headers, no projects and a welcome message
        _(page.title_heading.text).must_equal 'PortfolioAdvisor'
        _(page.company_name_input.present?).must_equal true
        _(page.show_target_button.present?).must_equal true
        _(page.histories_table.exists?).must_equal false

        _(page.success_message.present?).must_equal true
        _(page.success_message.text.downcase).must_include 'start'
    

      it '(HAPPY) should not see histories they did not request' do
        # GIVEN: a project exists in the database but GoogleNews has not requested it
        target = PortfolioAdvisor::GoogleNews::TargetMapper
          .new(GOOGLENEWS_TOKEN)
          .find(TOPIC, Date.today)
        PortfolioAdvisor::Repository::For.entity(target).create(target)
      end
    end
    
        # WHEN: user goes to the homepage
        visit HomePage do |page|

        # THEN: they should not see any companies
        _(page.histories_table.exists?).must_equal false
        end
    
      
    end

    describe 'Add History' do
      it '(HAPPY) should be able to request a company' do
        # GIVEN: user is on the home page without any projects
        visit HomePage do |page|

        # WHEN: they add a company name and submit
        good_target = TOPIC
        page.company_name_input.set(good_target)
        page.show_target_button.click

        # THEN: they should find themselves on the project's page
        @browser.url.include? TOPIC
      end
    end

      it '(BAD) should not be able to add an invalid company name' do
        # GIVEN: user is on the home page without any projects
        visit HomePage do |page|

        # WHEN: they request a project with an invalid URL
        bad_target = 'foobar'
        page.company_name_input.set(bad_target)
        page.show_target_button.click

        # THEN: they should see a warning message
        _(page.warning_message.present?).must_equal true
        _(page.warning_message.text.downcase).must_include 'not define'
        end
      end
    end
  end
end
end