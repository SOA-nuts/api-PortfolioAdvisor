# frozen_string_literal: true

folders = %w[targets industry_analysis]
folders.each do |folder|
  require_relative "#{folder}/init"
end