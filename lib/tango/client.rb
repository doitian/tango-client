require 'tango/default'
require 'tango/error'

require 'uri'
require 'faraday'

module Tango
  class Client
    # @return [Hash]
    attr_accessor :options

    # Initialize an instance with specified options. Unless an option is
    # specified, the corresponding value from {Tango::Default.options} is used.
    #
    # @param [Hash] options
    # @option options
    # @option options [String] username Tango account username
    # @option options [String] password Tango account password
    # @option options [String] endpoint API endpoint, the whole API URL prefix
    #   is "endpoint/version".
    # @option options [String] version version part of API URL
    # @option options [Faraday::Builder] middleware Faraday's middleware stack
    # @option options [Hash] connection_options Further options for Faraday connection
    def initialize(options = {})
      @options = ::Tango::Default.options.merge(options)
    end

    # Perform an HTTP POST request
    def post(path, params = {})
      request(:post, path, params)
    end

    def get_available_balance
      request :post, 'GetAvailableBalance'
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(endpoint, connection_options)
    end

    # Constructs endpoint from options
    #
    # @return [String]
    def endpoint
      options.values_at(:endpoint, :version).join('/')
    end

    private

    def request(method, path, params = {})
      path = path.sub(/^\//, '')
      params = params.merge credentials
      connection.send(method.to_sym, path, params).env
    rescue Faraday::Error::ClientError
      raise Tango::Error::ClientError
    rescue MultiJson::DecodeError
      raise Tango::Error::DecodeError
    end

    # Account credentials.
    #
    # @return [Hash] Account credentials
    def credentials
      {
        :username => options[:username],
        :password => options[:password]
      }
    end

    def connection_options
      options[:connection_options].merge(:builder => options[:middleware])
    end
  end
end
