require 'highwinds-api'

describe HighwindsAPI::Content do
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

  describe "basic functionaility" do
    let(:host_hash) { "xxxxxxxx" }
    let(:path) { "baz/*" }
    let(:url) { "http://foo.bar.com/baz" }
    let(:recursive) { false }
    let(:options) {
      options = {
      headers: {
        'Content-Type'  => 'application/xml',
        'Accept'        => 'application/xml'
      },
      basic_auth: HighwindsAPI.credentials }
    }

    describe ".purge_url" do
      it "calls delete with given params" do
        content.should_receive(:delete).\
          with("?recursive=#{recursive}&url=#{url}", options).\
          and_return("403")
        content.purge_url(url, recursive)
      end
    end

    describe ".purge_path" do
      it "calls delete with given params" do
        content.should_receive(:delete).\
          with("/#{host_hash}/cds/#{path.chop}", options).\
          and_return("403")
        content.purge_path(host_hash, path)
      end
    end
  end

end