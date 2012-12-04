require 'faraday'
require 'multi_json'

require 'tango/error'

module Tango
  module Response
    class ParseJson < Faraday::Response::Middleware

      def parse(body)
        case body
        when /\A^\s*$\z/, nil
          nil
        else
          json = MultiJson.load(body, :symbolize_keys => true)
          unless json.is_a?(Hash) && json[:response].is_a?(Hash) && json[:responseType] == 'SUCCESS'
            raise ::Tango::Error::ServerError.from_response(json)
          end

          json[:response]
        end
      end

      def on_complete(env)
        if respond_to?(:parse)
          env[:body] = parse(env[:body])
        end
      end

    end
  end
end
