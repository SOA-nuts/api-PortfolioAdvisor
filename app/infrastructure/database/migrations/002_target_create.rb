# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:targets) do
      primary_key :id
      String :company_name, unique: true
      # String :stock_symbol

      # DateTime :created_at
      Date :updated_at
      Integer :score
    end
  end
end
