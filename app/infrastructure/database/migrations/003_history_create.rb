# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:histories) do
      primary_key :id
      foreign_key :company_id, :targets

      Integer      :score
      Date        :updated_at
    end
  end
end
