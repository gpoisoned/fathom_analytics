require "bundler/setup"
require 'dotenv/load'
require 'vcr'
require 'pry'
require "fathom_analytics"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = { :record => :once }
  config.hook_into :faraday

  config.filter_sensitive_data('<TEST_URL>') { ENV['TEST_URL'] }
  config.filter_sensitive_data('<TEST_EMAIL>') { ENV['TEST_EMAIL'] }
  config.filter_sensitive_data('<TEST_PASSWORD>') { ENV['TEST_PASSWORD'] }
end
