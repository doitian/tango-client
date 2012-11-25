require 'faraday'

module FaradayStub
  def stub_request(connection)
    unless connection.options[:stubs]
      # Inject Faraday::Adapter::Test and rebuild the app
      connection.instance_variable_set(:@app, nil)
      index = connection.builder.handlers.size - 1
      stubs = Faraday::Adapter::Test::Stubs.new
      connection.builder.swap index, Faraday::Adapter::Test, stubs
      connection.options[:stubs] = stubs
    end

    yield connection.options[:stubs] if block_given?
  end

  alias_method :stub_connection, :stub_request

  def stub_get(connection, path, &block)
    stub_request(connection) do |stubs|
      stubs.get(path, &block)
    end
  end

  def stub_post(connection, path, body = nil, &block)
    stub_request(connection) do |stubs|
      stubs.post(path, body, &block)
    end
  end

  def stub_put(connection, path, body = nil, &block)
    stub_request(connection) do |stubs|
      stubs.put(path, body, &block)
    end
  end

  def stub_delete(connection, path, &block)
    stub_request(connection) do |stubs|
      stubs.delete(path, &block)
    end
  end
end
