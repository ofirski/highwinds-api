require 'highwinds-api'

describe HighwindsAPI::Content do
  let(:config) { YAML.load_file('spec/config.yml') }
  let(:client) { HighwindsAPI }
  let(:content) { client::Content }

  context "when credentials are incorrect" do
    before do
      client.clear_token
      client.set_credentials("bad-username", "bad-password")
    end

    it "does not purge content" do
      response = content.purge_url("http://staging.crossrider.com/kerker/", true).response
      expect(response.code).to eq("401")
    end
  end

  context "when credentials are correct" do
    before do
      client.clear_token
      client.set_credentials(config["username"], config["password"])
    end

    it "should purge content by url" do
      response = content.purge_url("http://staging.crossrider.com/kerker/", true)
      response.include?("id").should eq(true), "response was: #{response}"
    end

    it "should purge folder by path" do
      response = content.purge_path("y2s9x4y9", "/kerker/").response
      response.code.should eq("200"), "response was: #{response} and response code was #{response.code} and response text #{response.body}"
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
    let(:account_hash) {"d3b5s7n9"}

     describe ".purge_url" do
       it "calls post with given params" do
        HighwindsAPI.clear_token
        HighwindsAPI.set_credentials(config["username"], config["password"])      
        options = {
          :headers    =>  { 'Authorization'  => HighwindsAPI.get_token,
                'Content-Type' => 'application/json'},
          :body =>  {"list" => [{url: url, recursive: recursive }]}.to_json }
         
         content.should_receive(:post).\
           with("/api/v1/accounts/#{account_hash}/purge", options).\
           and_return("403")
         content.purge_url(url, recursive)
       end
     end


     describe ".purge_path" do
       it "calls post with given params" do
        HighwindsAPI.clear_token
        HighwindsAPI.set_credentials(config["username"], config["password"])      
        options = {
          :headers    =>  { 'Authorization'  => HighwindsAPI.get_token,
                'Content-Type' => 'application/json'},
          :body =>  {"list" => [{url: "http://cds.xxxxxxxx.hwcdn.net/baz/*", recursive: true }]}.to_json }
         content.should_receive(:post).\
           with("/api/v1/accounts/#{account_hash}/purge", options).\
           and_return("403")
         content.purge_path(host_hash, path)
       end
     end
  end

end