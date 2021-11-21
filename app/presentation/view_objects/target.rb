# frozen_string_literal: true

module Views
    class Target
        def initialize(target,index=nil)
            @target=target
            @index=index
        end
        def entity
            @target
        end
        def advisor_link
            "history/#{company_name}"
          end
        def company_name
            @target.company_name
        end
       def index_str
            "history[#{@index}]"
       end
       def date_updated
         @target.updated_at
       end
       def list_of_articles
        @target.articles
       end
       def related_article_title
        @target.articles.each{ |keys| keys[4]}
            
        
       end
       def related_article_score
      
      end
    end
end
