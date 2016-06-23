module HighwindsAPI
  require 'httparty'
  class Content
    include HTTParty
    # debug_output $stdout # adds HTTP debugging

    base_uri 'https://striketracker3.highwinds.com/'

    def self.purge_path(host_hash, path)
      list = [*path].map do |apath|
        purge_path = apath.sub(/^\/+/, '')
        { url: "http://cds.#{host_hash}.hwcdn.net/#{purge_path}", recursive: true }
      end
      purge(list)
    end

    def self.purge_url(url, recursive = false)
      purge([url: url, recursive: recursive])
    end

    def self.purge(list)
      options = {
        headers: {
          'Authorization' => HighwindsAPI.get_token,
          'Content-Type' => 'application/json'
        },
        body: { list: list }.to_json
      }
      self.post("/api/v1/accounts/#{get_account_hash}/purge", options)
    end

    private

    def self.get_token
      options = {
        body: {
          grant_type: 'password',
          username: HighwindsAPI.credentials[:username],
          password: HighwindsAPI.credentials[:password]
        }
      }

      response = self.post("/auth/token", body: options)
      "Bearer #{response['access_token']}"
    end

    def self.get_account_hash
      options = { headers: { 'Authorization' => HighwindsAPI.get_token } }
      response = self.get('/api/v1/users/me', options)
      response['accountHash']
    end
  end
end
