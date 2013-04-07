# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sodacan/version'

Gem::Specification.new do |spec|
  spec.name          = "sodacan"
  spec.version       = SodaCan::VERSION
  spec.authors       = ["Trevor John", "Tyler Heck"]
  spec.email         = ["tyler.heck+sodacan@gmail.com"]
  spec.description   = %q{Wrapper to make ActiveRecord type queries on Soda2 interfaces.}
  spec.summary       = %q{SOQL Wrapper for JSON Soda 2 interfaces}
  spec.homepage      = "http://rubygems.org/gems/sodacan"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "json", ["= 1.7.7"]
  spec.add_runtime_dependency "rest-client", ["= 1.6.7"]
end
