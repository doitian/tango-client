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

    it 'raises ServerError' do
      expect { env }.to raise_error(Tango::Error::ServerError)
    end
  end
  context 'POST {"responseType":"SUCCESS","response":"OK"}' do
    let(:env) { conn.post('/echo', %q[{"responseType":"SUCCESS","response":"OK"}]).env }

    it 'raise ServerError' do
      expect { env }.to raise_error(Tango::Error::ServerError)
    end
  end
  context 'POST {"responseType":"SUCCESS","response":{"status":"OK"}}' do
    let(:env) { conn.post('/echo', %q[{"responseType":"SUCCESS","response":{"status":"OK"}}]).env }

    it 'returns {:status => "OK"}' do
      env[:body].should == { :status => "OK" }
    end
  end
  context 'POST {"responseType":"INV_INPUT"}' do
    it 'raises InvInput' do
      expect {
        conn.post('/echo', %q[{"responseType":"INV_INPUT"}])
      }.to raise_error ::Tango::Error::InvInput
    end
  end
end

