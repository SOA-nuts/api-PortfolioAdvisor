# frozen_string_literal: true

folders = %w[database cache messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
