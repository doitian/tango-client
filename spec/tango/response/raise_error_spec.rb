require 'tango/response/raise_error'
require 'faraday'

describe Tango::Response::RaiseError do
  context 'error class raises if status code >= 500' do
    class Error < StandardError
      def self.from_status_code(status_code)
        new(status_code.to_s)
      end
      def self.raise_on?(status_code)
        status_code >= 500
      end
    end

    let(:conn) {
      Faraday::Connection.new do |conn|
        conn.use Tango::Response::RaiseError, Error

        conn.use Faraday::Adapter::Test do |stub|
          stub.get '/499' do |env|
            [ 400, {}, '' ]
          end
          stub.get '/500' do |env|
            [ 500, {}, '' ]
          end
        end
      end
    }

    it 'raises error if status code is 500' do
      expect {
        conn.get('/500')
      }.to raise_exception(Error)
    end
    it 'does not raise error if status code is 499' do
      expect {
        conn.get('/499')
      }.not_to raise_exception(Error)
    end
  end
end
