describe 'History Page' do
    it '(HAPPY) should see history content if history exists' do
      # GIVEN: a project exists
      target = PortfolioAdvisor::GoogleNews::TargetMapper
        .new(GOOGLENEWS_TOKEN)
        .find(TOPIC, Date.today)

      PortfolioAdvisor::Repository::For.entity(target).create(target)

      # WHEN: user goes directly to the project page
      visit(HistoryPage, using_params: {  "#{TOPIC}"}) do |date|

      #@browser.goto "http://localhost:9000/history/#{TOPIC}"

      # THEN: they should see the project details
      _(date.display_company_name.text).must_include TOPIC

      article_columns = date.company_history_table.organize_company_history_header

      _(article_columns.count).must_equal 2
    end
  end
end