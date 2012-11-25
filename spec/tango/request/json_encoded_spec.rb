require 'tango/request/json_encoded'
require 'faraday'

describe Tango::Request::JsonEncoded do
  let(:conn) {
    Faraday::Connection.new do |conn|
      conn.use Tango::Request::JsonEncoded

      conn.use Faraday::Adapter::Test do |stub|
        stub.post '/echo' do |env|
          # echo back request body
          [ 200, {:request_body => env[:body]}, env[:body] ]
        end
      end
    end
  }

  context 'POST {"string":"hello"} with no content type' do
    let(:env) { conn.post('/echo', :string => "hello").env }

    it 'dumps params to JSON' do
      env[:response_headers]['Request-Body'].should == %q({"string":"hello"})
    end

    it 'sets content type to application/json' do
      env[:request_headers]['Content-Type'].should == 'application/json'
    end
  end
end
