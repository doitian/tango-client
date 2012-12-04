require "tango/version"
require "tango/default"
require "tango/client"

module Tango
  class << self

    # Delegates to a client. The client is re-initialized after any
    # configuration option is changed.
    #
    # @return [Tango::Client]
    def client
      unless defined?(@client) && @client.options.hash == options.hash
        @client = ::Tango::Client.new(options)
      end

      @client
    end

    # Global options. New created {Tango::Client} instances observe options here.
    #
    # The {#client} instance is re-initialized after options are changed.
    #
    # @return [Hash]
    def options
      @options ||= ::Tango::Default.options.dup
    end

    if RUBY_VERSION >= "1.9"
      def respond_to_missing?(method_name, include_private=false)
        client.respond_to?(method_name, include_private)
      end
    else
      def respond_to?(method_name, include_private=false)
        client.respond_to?(method_name, include_private) || super
      end
    end

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end
end
