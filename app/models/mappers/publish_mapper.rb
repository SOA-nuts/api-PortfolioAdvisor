# frozen_string_literal: false

module PortfolioAdvisor
    # Provides access to contributor data
    module GoogleNews
      # Data Mapper: Github contributor -> Member entity
      class PublishMapper
        def initialize(publish)
            @publish = publish.map { |date| DateTime.strptime(date, '%Y-%m-%dT%H:%M:%S%z') }
            self.build_entity(@publish)
        end
  
        def build_entity(data)
          DataMapper.new(data).build_entity
        end
  
        # Extracts entity specific elements from data structure
        class DataMapper
          def initialize(data)
            @data = data
          end
  
          def build_entity
            Entity::Publish.new(
              dates: dates,
              times: times
            )
          end
  
          private
  
          def dates
            @data.map { |info| info.strftime('%Y-%m-%d') }
          end
  
          def times
            @data.map { |info| info.strftime('%H:%M:%S') }
          end
        end
      end
    end
  end