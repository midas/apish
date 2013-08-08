# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apish/version'

Gem::Specification.new do |gem|
  gem.authors       = ["C. Jason Harrelson (midas)"]
  gem.email         = ["jason@lookforwardenterprises.com"]
  gem.description   = %q{Apish provides a set of tools to aid in API creation and management.}
  gem.summary       = %q{Apish provides a set of tools to aid in API creation and management. These tools include but are not limited to version maangement and responders.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "apish"
  gem.require_paths = ["lib"]
  gem.version       = Apish::VERSION

  gem.add_development_dependency(%q<rspec>, ["~> 2"])

  gem.add_dependency(%q<activesupport>, [">= 2"])
  gem.add_dependency(%q<actionpack>,    [">= 2"])
  gem.add_dependency(%q<mime-types>,    [">= 1"])
end
