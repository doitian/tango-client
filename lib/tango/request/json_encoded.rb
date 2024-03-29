require 'faraday'
require 'multi_json'

module Tango
  module Request
    class JsonEncoded < Faraday::Response::Middleware
      CONTENT_TYPE = 'Content-Type'.freeze

      class << self
        attr_accessor :mime_type
      end
      self.mime_type = 'application/json'.freeze

      def call(env)
        match_content_type(env) do |data|
          env[:body] = MultiJson.dump data
        end
        @app.call env
      end

      def match_content_type(env)
        if process_request?(env)
          env[:request_headers][CONTENT_TYPE] ||= self.class.mime_type
          yield env[:body] unless env[:body].respond_to?(:to_str)
        end
      end

      def process_request?(env)
        type = request_type(env)
        env[:body] and (type.empty? or type == self.class.mime_type)
      end

      def request_type(env)
        type = env[:request_headers][CONTENT_TYPE].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      end

    end
  end
end
