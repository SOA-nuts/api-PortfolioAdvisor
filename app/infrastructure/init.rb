# frozen_string_literal: true

folders = %w[google_news crawler database cache messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
