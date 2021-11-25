# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url PortfolioAdvisor::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h1(:title_heading, id: 'main_header')
  text_field(:company_name_input, id: 'company_name_input')
  button(:add_button, id: 'company_form_submit')
  table(:histories_table, id: 'histories_table')

  indexed_property(
    :targets,
    [
      [:span,  :company_name,        { id: 'target[%s].company_name' }],
      [:td,    :date_updated,     { id: 'target[%s].date_updated' }]
    ]
  )

  def add_new_target(company_name)
    self.company_name_input = company_name
    self.add_button
  end
  
end