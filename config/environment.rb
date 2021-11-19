# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'sequel'
require 'delegate'
require 'yaml'

module CodePraise
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config() = Figaro.env
      
      use Rack::Session::Cookie, secret: config.SESSION_SECRET
      
      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

    configure :development, :test do
      require 'pry'; # for breakpoints
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    # Database Setup
    DB = Sequel.connect(ENV['DATABASE_URL'])
    # deliberately :reek:UncommunicativeMethodName calling method DB
    def self.DB() = DB # rubocop:disable Naming/MethodName
  end
end