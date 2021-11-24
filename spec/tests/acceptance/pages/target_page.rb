# frozen_string_literal: true

# Page object for target page
class TargetPage
    include PageObject
  
    page_url PortfolioAdvisor::App.config.APP_HOST
  
    
    h2(:display_company_name)
    text_field(:company_name_input, id: 'company_name_input')
    button(:show_target_button, id: 'company-form-submit')
    table(:article_scores_table, id: 'score_table')
  
    indexed_property(
      :projects,
      [
        [:span, :owner,        { id: 'project[%s].owner' }],
        [:a,    :http_url,     { id: 'project[%s].link' }],
        [:span, :contributors, { id: 'project[%s].contributors' }]
      ]
    )
    def organize_articles_header
        .thead.ths
      end
    
  end