# frozen_string_literal: true

folders = %w[google_news crawler database]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
