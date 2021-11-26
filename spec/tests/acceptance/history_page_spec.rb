# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/history_page'
require_relative 'pages/home_page'

describe 'Historypage Acceptance Tests' do
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
  it '(HAPPY) should see history content if history exists' do
    # GIVEN: a target exists
    # target = PortfolioAdvisor::GoogleNews::TargetMapper
    #   .new(GOOGLENEWS_TOKEN)
    #   .find(TOPIC, nil)

    # PortfolioAdvisor::Repository::For.entity(target).create(target)

    visit HomePage do |page|
      good_target = TOPIC
      page.add_new_target(good_target)
    end

    # WHEN: user goes directly to the history page
    visit(HistoryPage, using_params: {target_name: TOPIC}) do |page|

      # THEN: they should see the history details
      _(page.target_title).must_equal TOPIC
      _(page.historys_table_element.present?).must_equal true

      _(page.historys.count).must_equal 1
    end
    
    @browser.goto "http://localhost:9000/history/#{TOPIC}"

  end
end