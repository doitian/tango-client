module Tango
  class Error < StandardError
    class ClientError < Tango::Error; end
    class DecodeError < Tango::Error; end
  end
end
