# frozen_string_literal: true

folders = %w[google_news yahoo_finance crawler database cache]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
