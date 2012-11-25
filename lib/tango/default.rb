require 'tango/version'
require 'tango/request/json_encoded'
require 'tango/response/parse_json'
require 'faraday'

module Tango
  module Default
    INTEGRATION_ENDPOINT = 'https://int.tangocard.com'
    PRODUCTION_ENDPOINT = 'https://api.tangocard.com'

    ENDPOINT = INTEGRATION_ENDPOINT unless defined?(::Tango::Default::ENDPOINT)

    MIDDLEWARE = Faraday::Builder.new do |builder|
      # Encode request params into JSON for PUT/POST requests
      builder.use ::Tango::Request::JsonEncoded

      # Parse response JSON
      builder.use ::Tango::Response::ParseJson

      builder.adapter Faraday.default_adapter

    end unless defined?(::Tango::Default::MIDDLEWARE)

    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
        :user_agent => "TangoClient Ruby Gem #{::Tango::VERSION}"
      },
      :open_timeout => 5,
      :raw => true,
      :ssl => {
        :ca_file => File.expand_path('../ssl/cacert.pem')
      },
      :timeout => 10,
    } unless defined?(::Tango::Default::CONNECTION_OPTIONS)

    VERSION = 'Version2' unless defined?(::Tango::Default::VERSION)

    def self.options
      {
        :username => ENV['TANGO_USERNAME'] || 'third_party_int@tangocard.com',
        :password => ENV['TANGO_PASSWORD'] || 'integrateme',
        :endpoint => ENDPOINT,
        :version => VERSION,
        :middleware => MIDDLEWARE.dup,
        :connection_options => CONNECTION_OPTIONS.clone
      }
    end
  end
end
