# frozen_string_literal: true

# Page object for home page
class HomePage
    include PageObject
  
    page_url PortfolioAdvisor::App.config.APP_HOST
  
    div(:warning_message, id: 'flash_bar_danger')
    div(:success_message, id: 'flash_bar_success')
  
    h1(:title_heading, id: 'main_header')
    text_field(:company_name_input, id: 'company_name_input')
    button(:show_target_button, id: 'company-form-submit')
    table(:histories_table, id: 'histories_table')
  
    indexed_property(
      :projects,
      [
        [:span, :owner,        { id: 'project[%s].owner' }],
        [:a,    :http_url,     { id: 'project[%s].link' }],
        [:span, :contributors, { id: 'project[%s].contributors' }]
      ]
    )
  
    
  end