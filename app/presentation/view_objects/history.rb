module Views
   # View for a single history
    class History
     def initialize(history)
        @history=history
     end

     def entity
        @history
     end

     def updated_at
        @history.updated_at
     end

     def score 
        @history.score
     end
   end
end
