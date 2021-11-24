# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/target_page'
require_relative 'pages/home_page'

describe 'Targetpage Acceptance Tests' do
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
  it '(HAPPY) should see target content if target exists' do
    # GIVEN: user has requested and created a target
    visit HomePage do |page|
      good_target = TOPIC
      page.add_new_target(good_target)
    end

    # WHEN: they add a target and submit
    visit(TargetPage, using_params: {target_name: TOPIC}) do |page|

      # THEN: they should see the target details
      _(page.target_title).must_equal TOPIC
      _(page.articles_table_element.present?).must_equal true

      _(page.articles.count).must_equal 15
    end
  end
end
