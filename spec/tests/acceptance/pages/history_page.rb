# frozen_string_literal: true

# Page object for history page
class HistoryPage
  include PageObject

  page_url PortfolioAdvisor::App.config.APP_HOST +
           '/history/<%=params[:target_name]%>' 

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h2(:target_title, id: 'target_name')
  table(:historys_table, id: 'history_table')

  indexed_property(
    :historys,
    [
      [:td, :updated_at, { id: 'history.updated_at' }],
      [:td, :score, { id: 'history.score' }]
    ]
  )

  def historys
    historys_table_element.trs(id: 'history_row')
  end
end