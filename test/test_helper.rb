ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join "test/vcr"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = false
  c.filter_sensitive_data("{OPENAI_API_KEY}"){ ENV.fetch("OPENAI_API_KEY") }
  c.filter_sensitive_data("{RESEMBLE_API_KEY}"){ ENV.fetch("RESEMBLE_API_KEY") }
  c.filter_sensitive_data("{BASE_URL}"){ ENV.fetch("BASE_URL") }
  c.filter_sensitive_data("{RESEMBLE_VOICE_ID}"){ ENV.fetch("RESEMBLE_VOICE_ID") }
  c.filter_sensitive_data("{RESEMBLE_PROJECT_ID}"){ ENV.fetch("RESEMBLE_PROJECT_ID") }
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
