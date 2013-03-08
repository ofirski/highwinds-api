require 'highwinds-api'

describe HighwindsAPI do

  it "set credentials" do
    username = "user"
    password = "pass"
    subject.set_credentials(username, password)
    subject.credentials.should eq({ username: username, password: password })
  end

  it "autoloads ::Content" do
    # subject.autoload?(:Content).should eq("highwinds-api/content")
    subject::Content.should eq(HighwindsAPI::Content)
  end
end