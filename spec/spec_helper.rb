require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'webmock/rspec'
require 'highwinds-api'

def load_config
  if ENV['HIGHWINDS_TEST_REMOTE']
    YAML.load_file('spec/config.yml')
  else
    { "username" => "u", "password" => "p" }
  end
end

WebMock.disable_net_connect! if ENV['HIGHWINDS_TEST_REMOTE']
