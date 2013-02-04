require 'rspec'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'highwinds-api'))

describe 'HighwindsAPI' do
  username = "user"
  password = "pass"
  it "set credentials" do
    HighwindsAPI.set_credentials(username, password)
    HighwindsAPI.credentials.should eq({:username => username, :password => password})
  end
end