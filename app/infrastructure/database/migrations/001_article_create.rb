# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id

      String      :title, unique: true, null: false
      String      :url

      DateTime :published_at
    end
  end
end