require 'faraday'

module Tango
  module Response
    class RaiseError < Faraday::Response::Middleware
      def on_complete(env)
        status_code = env[:status].to_i
        if @klass.raise_on?(status_code)
          raise @klass.from_status_code(status_code)
        end
      end

      def initialize(app, klass)
        @klass = klass
        super(app)
      end
    end
  end
end
