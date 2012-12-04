require 'faraday'
require 'multi_json'
require 'tango/client'

require File.expand_path('../../spec_helper', __FILE__)

describe Tango::Client do

  include FaradayStub

  let(:account_credentials) {
    {
      :username => 'ian',
      :password => 'secret'
    }
  }

  let(:client) { Tango::Client.new account_credentials }

  let(:url_prefix) { '/' + client.options[:version] }

  subject { client }
  before { stub_request(client.connection) }

  describe '#get_available_balance' do
    let(:response) {
      {
        :responseType => 'SUCCESS',
        :response => { :availableBalance => 873431432 }
      }
    }

    before do
      stub_post(client.connection, url_prefix + '/GetAvailableBalance') do |env|
        [ 200, {:request_body => env[:body]}, MultiJson.dump(response) ]
      end
    end

    subject { client.get_available_balance }
    it { should == 873431432 }
  end
end
