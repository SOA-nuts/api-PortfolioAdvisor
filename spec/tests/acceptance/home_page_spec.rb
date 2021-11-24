# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage  Acceptance Tests' do
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
  describe 'Visit Home page' do
    it '(HAPPY) should not see histories if none created' do
      # GIVEN: user is on the home page without any targets
      # WHEN: they visit the home page
      visit HomePage do |page|

        # THEN: user should see basic headers, no targets and a welcome message
        _(page.title_heading).must_equal 'PortfolioAdvisor'
        _(page.company_name_input_element.present?).must_equal true
        _(page.show_target_button_element.present?).must_equal true
        _(page.histories_table_element.exists?).must_equal false

        _(page.success_message_element.present?).must_equal true
        _(page.success_message.downcase).must_include 'start'
      end  
    end    
    it '(HAPPY) should not see histories they did not request' do
      # GIVEN: a target exists in the database but GoogleNews has not requested it
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC, Date.today)
      PortfolioAdvisor::Repository::For.entity(target).create(target)
  
      # WHEN: user goes to the homepage
      visit HomePage do |page|
        # THEN: they should not see any targets
        _(page.histories_table_element.exists?).must_equal false
      end
    end
  end

  describe 'Add History' do
    it '(HAPPY) should be able to request a company' do
      # GIVEN: user is on the home page without any targets
      visit HomePage do |page|

        # WHEN: they add a targets URL and submit
        good_target = TOPIC
        page.add_new_target(good_target)

        # THEN: they should find themselves on the target's page
        @browser.url.include? TOPIC
      end
    end
    it '(BAD) should not be able to add an invalid company name' do
      # GIVEN: user is on the home page without any targets
      visit HomePage do |page|

        # WHEN: they request a target with an invalid URL
        bad_target = 'foobar'
        page.add_new_target(bad_target)

        # THEN: they should see a warning message
        _(page.warning_message.downcase).must_include 'not define'
      end
    end
  end
end