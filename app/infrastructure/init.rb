# frozen_string_literal: true

folders = %w[google_news yahoo_finance crawler database cache messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
