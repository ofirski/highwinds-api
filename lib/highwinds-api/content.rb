module HighwindsAPI
  require 'httparty'
  class Content
    include HTTParty
    # debug_output $stdout # adds HTTP debugging

    base_uri 'https://striketracker3.highwinds.com/'

    def self.purge_url(url, recursive)
      options = {
      :headers    =>  { 'Authorization'  => HighwindsAPI.get_token,
        'Content-Type' => 'application/json'},
      :body =>  {"list" => [{url: url, recursive: recursive }]}.to_json }
      self.post("/api/v1/accounts/#{get_account_hash}/purge", options)
    end

    # This method returns the last item post result
    def self.purge_path(host_hash, path)
      paths =[*path]
      paths = paths.map {|single_path| single_path.start_with?('/') ? single_path : '/' << single_path }
      res=nil
      paths.each do |path|
        options = {
        :headers    =>  { 'Authorization'  => HighwindsAPI.get_token, 
                          'Content-Type' => 'application/json'},
        :body =>  {"list" => [{url: "http://cds.#{host_hash}.hwcdn.net#{path}", recursive: true }]}.to_json }
        res = self.post("/api/v1/accounts/#{get_account_hash}/purge", options)
      end
      res
    end
    private
    def self.get_token
      response = self.post("/auth/token", {body: {grant_type: 'password', username: "#{HighwindsAPI.credentials[:username]}", password: "#{HighwindsAPI.credentials[:password]}"}})
      "Bearer #{response['access_token']}"      
    end
    def self.get_account_hash
      options = {
        :headers    =>  { 'Authorization'  => HighwindsAPI.get_token }
      }
      me = self.get('/api/v1/users/me', options)
      me['accountHash'] if me.include?('accountHash')
    end
  end
end