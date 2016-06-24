require 'spec_helper'

describe HighwindsAPI::Content do
  let(:config) { load_config }
  let(:client) { HighwindsAPI }
  let(:content) { client::Content }

  context "when credentials are incorrect" do
    before do
      client.clear_token
      client.set_credentials("bad-username", "bad-password")
    end

    it "does not purge content" do
      stub_request(:post, "https://striketracker3.highwinds.com/auth/token").
        with(:body => "grant_type=password&username=bad-username&password=bad-password").
        to_return(status: 401, body: '{"error": "This endpoint requires authentication","code": 203}', :headers => { content_type: 'application/json' })

      stub_request(:get, "https://striketracker3.highwinds.com/api/v1/users/me").
        with(:headers => {'Authorization'=>'Bearer'}).
        to_return(status: 401, body: '{"error": "This endpoint requires authentication","code": 203}', :headers => { content_type: 'application/json' })

      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts//purge").
        with(body: "{\"list\":[{\"url\":\"http://staging.crossrider.com/kerker/\",\"recursive\":true}]}").
        to_return(status: 401, body: '{"error": "This endpoint requires authentication","code": 203}', :headers => { content_type: 'application/json' })

      response = content.purge_url("http://staging.crossrider.com/kerker/", true).response
      expect(response.code).to eq("401")
    end
  end

  context "when credentials are correct" do
    before do
      client.clear_token
      client.set_credentials(config["username"], config["password"])

      stub_request(:post, "https://striketracker3.highwinds.com/auth/token").
        with(:body => "grant_type=password&username=u&password=p").
        to_return(:status => 200, :body => '{"access_token": "atoken"}', :headers => { content_type: 'application/json' })

      stub_request(:get, "https://striketracker3.highwinds.com/api/v1/users/me").
        with(:headers => {'Authorization'=>'Bearer atoken'}).
        to_return(:status => 200, :body => '{"accountHash": "12345"}', :headers => { content_type: 'application/json' })
    end

    it "should purge content by url" do
      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge").
        with(:body => "{\"list\":[{\"url\":\"http://staging.crossrider.com/kerker/\",\"recursive\":true}]}",
             :headers => {'Authorization'=>'Bearer atoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => '{"id":"id"}', :headers => { content_type: 'application/json' })

      response = content.purge_url("http://staging.crossrider.com/kerker/", true)
      response.include?("id").should eq(true), "response was: #{response}"
    end

    it "should purge folder by path" do
      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge").
        with(:body => "{\"list\":[{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/\",\"recursive\":true}]}",
             :headers => {'Authorization'=>'Bearer atoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => '{"id":"id"}', :headers => { content_type: 'application/json' })

      response = content.purge_path("y2s9x4y9", "/kerker/").response
      response.code.should eq("200"), "response was: #{response} and response code was #{response.code} and response text #{response.body}"
    end

    it "should purge file by path" do
      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge").
        with(:body => "{\"list\":[{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai\",\"recursive\":true}]}",
             :headers => {'Authorization'=>'Bearer atoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => '{"id":"id"}', :headers => { content_type: 'application/json' })

      response = content.purge_path("y2s9x4y9", "kerker/akamai").response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should purge folders by array of paths" do
      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge").
        with(:body => "{\"list\":[{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.txt\",\"recursive\":true},{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.htm\",\"recursive\":true},{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.gif\",\"recursive\":true}]}",
             :headers => {'Authorization'=>'Bearer atoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => '{"id":"id"}', :headers => { content_type: 'application/json' })

      arr = ["kerker/akamai.txt", "kerker/akamai.htm", "kerker/akamai.gif"]
      response = content.purge_path("y2s9x4y9", arr).response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should purge list of urls" do
      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge").
        with(:body => "{\"list\":[{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.txt\",\"recursive\":true},{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.htm\",\"recursive\":true},{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.gif\",\"recursive\":true}]}",
             :headers => {'Authorization'=>'Bearer atoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => '{"id":"id"}', :headers => { content_type: 'application/json' })

      arr = [
        { url: "http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.txt", recursive: true},
        { url: "http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.htm", recursive: true},
        { url: "http://cds.y2s9x4y9.hwcdn.net/kerker/akamai.gif", recursive: true}
      ]
      response = content.purge(arr).response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should ignore paths ending with * (purge by path is allways recuresive)" do
      stub_request(:post, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge").
        with(:body => "{\"list\":[{\"url\":\"http://cds.y2s9x4y9.hwcdn.net/kerker/*\",\"recursive\":true}]}",
             :headers => {'Authorization'=>'Bearer atoken', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => '{"id":"id"}', :headers => { content_type: 'application/json' })

      response = content.purge_path("y2s9x4y9", "kerker/*").response
      response.code.should eq("200"), "response was: #{response}"
    end

    it "should get progress for purge id" do
      stub_request(:get, "https://striketracker3.highwinds.com/api/v1/accounts/12345/purge/987654321").
        with(:headers => {'Authorization'=>'Bearer atoken'}).
        to_return(:status => 200, :body => '{"progress":1}', :headers => {})

      response = content.purge_progress("987654321").response
      response.code.should eq("200"), "response was: #{response}"
    end

  end

  describe "basic functionaility" do
    let(:host_hash) { "xxxxxxxx" }
    let(:path) { "baz/*" }
    let(:url) { "http://foo.bar.com/baz" }
    let(:recursive) { false }
    let(:account_hash) {"d3b5s7n9"}

    before do
      client.clear_token
      client.set_credentials(config["username"], config["password"])

      stub_request(:post, "https://striketracker3.highwinds.com/auth/token").
        with(:body => "grant_type=password&username=u&password=p").
        to_return(:status => 200, :body => '{"access_token":"atoken"}', :headers => { content_type: 'application/json' })

      stub_request(:get, "https://striketracker3.highwinds.com/api/v1/users/me").
        with(:headers => {'Authorization'=>'Bearer atoken'}).
        to_return(:status => 200, :body => '{"accountHash":"d3b5s7n9"}', :headers => { content_type: 'application/json' })

      HighwindsAPI.clear_token
      HighwindsAPI.set_credentials(config["username"], config["password"])
    end

    describe ".purge_url" do

      it "calls post with given params" do
        options = {
          :headers => { 'Authorization' => HighwindsAPI.get_token,
                        'Content-Type' => 'application/json' },
          :body => {"list" => [{ url: url, recursive: recursive }] }.to_json
        }

        content.should_receive(:post).
          with("/api/v1/accounts/#{account_hash}/purge", options).
          and_return("403")
        content.purge_url(url, recursive)
      end
    end


    describe ".purge_path" do
      it "calls post with given params" do
        options = {
          :headers => { 'Authorization' => HighwindsAPI.get_token,
                        'Content-Type' => 'application/json' },
          :body => { "list" => [{ url: "http://cds.xxxxxxxx.hwcdn.net/baz/*", recursive: true }] }.to_json
        }
        content.should_receive(:post).\
          with("/api/v1/accounts/#{account_hash}/purge", options).
          and_return("403")
        content.purge_path(host_hash, path)
      end
    end

    describe ".purge" do
      it "calls post with given params" do
        options = {
          :headers => { 'Authorization' => HighwindsAPI.get_token,
                        'Content-Type' => 'application/json' },
          :body => { "list" => [{ url: "http://cds.xxxxxxxx.hwcdn.net/baz/*", recursive: true }] }.to_json
        }
        content.should_receive(:post).\
          with("/api/v1/accounts/#{account_hash}/purge", options).
          and_return("403")
        content.purge([{ url: "http://cds.xxxxxxxx.hwcdn.net/baz/*", recursive: true }])
      end
    end

    describe ".purge_progress" do
      it "calls get" do
        purge_id = "987654321"
        options = { :headers => { 'Authorization' => HighwindsAPI.get_token } }

        content.should_receive(:get).\
          with("/api/v1/users/me", options).
          and_return({"accountHash" => account_hash})

        content.should_receive(:get).\
          with("/api/v1/accounts/#{account_hash}/purge/#{purge_id}", options).
          and_return({"progress": 1})

        content.purge_progress(purge_id)
      end
    end
  end
end
