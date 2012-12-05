lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tango/version'

Gem::Specification.new do |gem|
  gem.name          = "tango-client"
  gem.version       = Tango::VERSION
  gem.authors       = ["Ian Yang"]
  gem.email         = ["ian@intridea.com"]
  gem.description   = %q{HTTP client to ease using Tango API}
  gem.summary       = %q{HTTP client to ease using Tango API}
  gem.homepage      = "http://github.com/doitian/tango-client"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'faraday', '~> 0.8'
  gem.add_dependency 'multi_json', '~> 1.3'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
