module HighwindsAPI
  require 'httparty'
  class Content
    include HTTParty
    # debug_output $stdout # adds HTTP debugging 

    base_uri 'https://striketracker2.highwinds.com/webservices/content/'

    def self.purge_url(url, recursive)
      options = {
      :headers    =>  { 'Content-Type'  => 'application/xml', 
                        'Accept'        => 'application/xml' },
      :basic_auth =>  HighwindsAPI.credentials }
      self.delete("?recursive=#{recursive}&url=#{url}", options)
    end

    def self.purge_path(host_hash, path)
      options = {
      :headers    =>  { 'Content-Type'  => 'application/xml', 
                        'Accept'        => 'application/xml' },
      :basic_auth =>  HighwindsAPI.credentials }
      res = nil
      if path.is_a? Array
        path.each do |url|
          res = self.delete("/#{host_hash}/cds/#{url.chomp('*')}", options)
        end 
      else
        res = self.delete("/#{host_hash}/cds/#{path.chomp('*')}", options)  
      end
      res
    end

  end
end