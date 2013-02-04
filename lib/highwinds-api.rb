require "highwinds-api/version"

module HighwindsAPI

  def self.credentials
    { :username => @username,
      :password => @password }
  end

  def self.set_credentials(username, password)
      @username = username
      @password = password
  end

end
