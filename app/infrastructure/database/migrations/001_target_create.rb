# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:targets) do
      primary_key :id
      String      :company_name, unique: true
      Date        :updated_at
      Float       :article_score
      Float       :market_price
      Float       :bench_price
      Float       :grow_score
    end
  end
end
