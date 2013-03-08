require 'highwinds-api'

describe 'HighwindsAPI::Content' do
  let(:config) { YAML.load_file('spec/config.yml') }
  let(:client) { HighwindsAPI }
  let(:content) { client::Content }

  context "when credentials are incorrect" do
    before do
      client.set_credentials("bad-username", "bad-password")
    end

    it "does not purge content" do
      response = content.purge_url("http://staging.crossrider.com/kerker/", true).response
      response.code.should eq("403"), "response was: #{response}"
    end
  end

  context "when credentials are correct" do
    before do
      client.set_credentials(config["username"], config["password"])
    end

    it "should purge content by url" do
      response = content.purge_url("http://staging.crossrider.com/kerker/", true).response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should purge folder by path" do
      response = content.purge_path("y2s9x4y9", "kerker/").response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should purge file by path" do
      response = content.purge_path("y2s9x4y9", "kerker/akamai").response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should purge folders by array of pathes" do
      arr = ["kerker/akamai.txt", "kerker/akamai.htm", "kerker/akamai.gif"]
      response = content.purge_path("y2s9x4y9", arr).response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should ignore pathes ending with * (purge by path is allways recuresive)" do
      response = content.purge_path("y2s9x4y9", "kerker/*").response
      response.code.should eq("200"), "response was: #{response}"
    end
  end

end