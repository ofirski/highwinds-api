module HighwindsAPI
  require 'httparty'
  class Content
    include HTTParty
  
    base_uri 'https://striketracker2.highwinds.com/webservices/content/'
    
    def self.purge_url(url, recursive)
      options = {
          :headers    =>  { 'Content-Type'  => 'application/xml', 
                            'Accept'        => 'application/xml' },
          :basic_auth =>  HighwindsAPI.credentials 
      }
      self.delete("?recursive=#{recursive}&url=#{url}", options)
    end

  end
end