require "#{File.dirname(__FILE__)}/spec_setup"
require 'rack/cache/key'

describe 'A Rack::Cache::Key' do
  it "sorts params" do
    request = mock_request('/test?z=last&a=first')
    new_key(request).should.include('a=first&z=last')
  end

  it "includes host" do
    request = mock_request('/test', "HTTP_HOST" => 'www2.example.org')
    new_key(request).should.include('www2.example.org')
  end

  it "includes path" do
    request = mock_request('/test')
    new_key(request).should.include('/test')
  end

  it "is in order of host, path, params" do
    request = mock_request('/test?x=y', "HTTP_HOST" => 'www2.example.org')
    new_key(request).should == "www2.example.org/test?x=y"
  end

  # Helper Methods =============================================================

  define_method :mock_request do |*args|
    uri, opts = args
    env = Rack::MockRequest.env_for(uri, opts || {})
    Rack::Cache::Request.new(env)
  end

  define_method :new_key do |request|
    Rack::Cache::Key.call(request)
  end
end
