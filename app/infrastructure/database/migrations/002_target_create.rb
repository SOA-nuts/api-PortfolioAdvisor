# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:target) do
      primary_key :id
      foreign_key :article_id, :articles

      String     :company_name, unique: true

    end
  end
end