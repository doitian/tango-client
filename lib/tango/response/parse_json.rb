require 'faraday'
require 'multi_json'

module Tango
  module Response
    class ParseJson < Faraday::Response::Middleware

      def parse(body)
        case body
        when /\A^\s*$\z/, nil
          nil
        else
          MultiJson.load(body, :symbolize_keys => true)
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
