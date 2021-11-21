module Views
    class History
     def initialize(history,company)
        @history=history
        @company=company
     end
     def entity
        @history
     end
     def date_updated
        @history.updated_at
     end
     def rating 
        @history.score
     end
   
    
    end
end
