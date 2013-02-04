require 'rspec'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'highwinds-api'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'highwinds-api/content'))

describe 'HighwindsAPI::Content' do
  username = "<Your username>"
  password = "<Your password>"
  it "should not purge content, if username and password are not correct." do
    HighwindsAPI.set_credentials(username, password)
    r = HighwindsAPI::Content.purge_url("http://staging.crossrider.com/kerker/", true).response
    r.code.should eq("403"), "response was: #{r}"
  end

  xit "should purge content" do
    HighwindsAPI.set_credentials(username, password)
    r = HighwindsAPI::Content.purge_url("http://staging.crossrider.com/kerker/", true).response
    r.code.should eq("200"), "response was: #{r}"
  end

end