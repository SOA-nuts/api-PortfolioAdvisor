# frozen_string_literal: true

describe 'Target Page' do
    it '(HAPPY) should see project content if project exists' do
        visit TargetPage do |page|

      # WHEN: they add a project URL and submit
      good_target = TOPIC
      page.company_name_input.set(good_target)
      page.show_target_button.click

      # THEN: they should redirect to target page and see the project details
      _(page.display_company_name.text).must_include TOPIC

      article_columns = page.article_scores_table.organize_articles_header

      _(article_columns.count).must_equal 2
    end
  end