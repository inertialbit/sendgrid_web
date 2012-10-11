# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid_web/version'

Gem::Specification.new do |gem|
  gem.name          = "sendgrid_web"
  gem.version       = SendgridWeb::VERSION
  gem.authors       = ["Jeremiah Heller"]
  gem.email         = ["ib.jeremiah@gmail.com"]
  gem.description   = %q{Ruby interface for working with SendGrid's Web (HTTP) API. Read more at http://docs.sendgrid.com/documentation/api/web-api/.}
  gem.summary       = %q{Provides CLI and API and works on ruby 1.8.7, 1.9.2, 1.9.3 and rack.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("faraday", ["= 0.8.4"])
end
