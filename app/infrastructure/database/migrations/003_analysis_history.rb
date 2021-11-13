# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:analyses) do
      primary_key :id
      foreign_key :company_id, :targets

      String      :score,
      Date        :analyzed_at
    end
  end
end
