# frozen_string_literal: true

# Page object for target page
class TargetPage
  include PageObject

  page_url PortfolioAdvisor::App.config.APP_HOST +
           '/target/<%=params[:target_name]%>' 

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h2(:target_title, id: 'target_name')
  table(:articles_table, id: 'score_table')

  indexed_property(
    :articles,
    [
      [:td, :title, { id: 'article.title' }],
      [:td, :score, { id: 'article.score' }]
    ]
  )

  def articles
    articles_table_element.trs(id: 'article_row')
  end
end