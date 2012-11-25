require 'tango/response/parse_json'
require 'faraday'

describe Tango::Response::ParseJson do
  let(:conn) {
    Faraday::Connection.new do |conn|
      conn.use Tango::Response::ParseJson

      conn.use Faraday::Adapter::Test do |stub|
        stub.post '/echo' do |env|
          # echo back request body
          [ 200, {}, env[:body] ]
        end
      end
    end
  }

  context 'POST {"string":"hello"} with no content type' do
    let(:env) { conn.post('/echo', %q[{"string":"hello"}]).env }

    it 'parse response JSON to object' do
      env[:body].should == { :string => 'hello' }
    end
  end
end

