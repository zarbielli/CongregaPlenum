# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path('../cassettes', __dir__)
  config.hook_into :webmock
  config.default_cassette_options = {
    record: :once,
    match_requests_on: %i[method uri]
  }
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost = true

  config.filter_sensitive_data('<USER_AGENT>') { 'CongregaPlenum/1.0' }
end
