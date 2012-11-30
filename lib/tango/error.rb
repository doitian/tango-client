module Tango
  class Error < StandardError
    attr_accessor :status_code

    # Creates a new Error object from status_code
    #
    # @param status_code [Integer] HTTP response status code
    # @return [Tango::Error]
    def self.from_status_code(status_code)
      ex = new("Error: #{status_code}")
      ex.status_code = status_code
      ex
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @return [Tango::Error]
    def initialize(exception = $!)
      @wrapped_exception = exception
      exception.respond_to?(:backtrace) ? super(exception.message) : super(exception.to_s)
    end

    def backtrace
      @wrapped_exception.respond_to?(:backtrace) ? @wrapped_exception.backtrace : super
    end

    class ClientError < Tango::Error;
    end

    class ServerError < Tango::Error;
      attr_accessor :response

      # Fetches value from response by key
      #
      # @param key [Symbol]
      def [](key)
        response[key] if response
      end

      # Convert response type to class name
      def self.response_type_to_class_name(type)
        type.split('_').collect(&:capitalize).join('')
      end

      def self.from_response(body)
        if body && body[:responseType]
          type = body[:responseType]
          class_name = response_type_to_class_name(type)
          if Tango::Error.const_defined?(class_name)
            ex = Tango::Error.const_get(class_name).new(body[:response])
          else
            ex = new(body[:response])
          end
          ex.response = body[:response]
          ex
        else
          new(body)
        end
      end
    end

    class InvCredential < ServerError; end
    class InvInput < ServerError; end
    class InsInv < ServerError; end
    class InsFunds < ServerError; end
    class SysError < ServerError; end

    class DecodeError < Tango::Error; end
  end
end
