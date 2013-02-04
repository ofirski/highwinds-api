# Highwinds::Api

This is a Ruby implementation of Highwinds REST API.

## Installation

Add this line to your application's Gemfile:

    gem 'highwinds-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install highwinds-api

## Usage

In order to use this gem follow the installation instructions and properly set your credentials:
  	username = "<Your username>"
  	password = "<Your password>"
	HighwindsAPI.set_credentials(username, password)

Purge by path:

	HighwindsAPI::Content.purge_url("http://path.to.folder/or_a_file")

Purge recursivly:

	HighwindsAPI::Content.purge_url("http://path.to.folder/", true)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
