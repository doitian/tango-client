require 'tango/version'
require 'tango/error'
require 'tango/request/json_encoded'
require 'tango/response/parse_json'
require 'tango/response/raise_error'
require 'faraday'

module Tango
  module Default
    INTEGRATION_ENDPOINT = 'https://int.tangocard.com' unless defined?(::Tango::Default::INTEGRATION_ENDPOINT)
    PRODUCTION_ENDPOINT = 'https://api.tangocard.com' unless defined?(::Tango::Default::PRODUCTION_ENDPOINT)

    ENDPOINT = INTEGRATION_ENDPOINT unless defined?(::Tango::Default::ENDPOINT)

    MIDDLEWARE = Faraday::Builder.new do |builder|
      # Encode request params into JSON for PUT/POST requests
      builder.use ::Tango::Request::JsonEncoded

      builder.use ::Tango::Response::RaiseError, ::Tango::Error::ClientError

      # Parse response JSON
      builder.use ::Tango::Response::ParseJson

      builder.use ::Tango::Response::RaiseError, ::Tango::Error::ServerError

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
      @options ||= {
        :username => ENV['TANGO_USERNAME'] || 'third_party_int@tangocard.com',
        :password => ENV['TANGO_PASSWORD'] || 'integrateme',
        :endpoint => ENV['TANGO_ENDPOINT'] || ENDPOINT,
        :version => VERSION,
        :middleware => MIDDLEWARE,
        :connection_options => CONNECTION_OPTIONS
      }
    end

    def self.template
      template = options.dup
      template[:middleware] = options[:middleware].dup
      template[:connection_options] = options[:connection_options].dup

      template
    end
  end
end
