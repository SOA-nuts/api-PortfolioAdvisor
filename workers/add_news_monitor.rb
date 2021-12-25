# frozen_string_literal: true

module NewsAdd
  # Infrastructure to add while yielding progress
  module AddMonitor
    ADD_PROGRESS = {
      'STARTED'   => 15,
      'Adding'   => 30,
      'remote'    => 70,
      'Receiving' => 85,
      'Resolving' => 95,
      'Checking'  => 100,
      'FINISHED'  => 100
    }.freeze

    def self.starting_percent
      ADD_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      ADD_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      ADD_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      ADD_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
