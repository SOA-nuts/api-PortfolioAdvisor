# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:histories) do
      primary_key :id
      foreign_key :company_id, :targets

      Float       :article_score
      Float       :market_price
      Float       :bench_price
      Float       :grow_score
    end
  end
end
