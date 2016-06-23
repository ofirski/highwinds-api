# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'highwinds-api/version'

Gem::Specification.new do |gem|
  gem.name          = "highwinds-api"
  gem.version       = Highwinds::Api::VERSION
  gem.authors       = ["Ofir Kerker"]
  gem.email         = ["ofir@crossrider.com"]
  gem.description   = %q{Ruby implementation of Highwinds REST API}
  gem.summary       = %q{Ruby implementation of Highwinds REST API}
  gem.homepage      = "https://github.com/kerkero/highwinds-api"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "httparty", "0.10.2"
  gem.add_development_dependency "rspec", "~> 2.11"
  gem.add_development_dependency "webmock"
end
