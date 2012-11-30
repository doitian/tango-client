require 'tango/error'

describe Tango::Error do
  describe '.from_status_code' do
    context 'when status code is 404' do
      subject { Tango::Error.from_status_code(404) }
      its(:message) { should == 'Error: 404' }
    end
  end
end

describe Tango::Error::ServerError do
  describe '.from_response' do
    context 'when responseType is Unknown' do
      subject {
        Tango::Error::ServerError.from_response(:responseType => 'Unknown',
                                                :response => 'test')
      }

      it { should be_a_kind_of(Tango::Error::ServerError) }
      its(:response) { should == 'test' }
    end
    context 'when responseType is INV_CREDENTIAL' do
      subject {
        Tango::Error::ServerError.from_response(:responseType => 'INV_CREDENTIAL',
                                                :response => 'test')
      }

      it { should be_a_kind_of(Tango::Error::InvCredential) }
    end
  end
end
