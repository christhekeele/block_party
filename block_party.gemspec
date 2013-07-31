# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'block_party/version'

Gem::Specification.new do |spec|
  spec.name          = "block_party"
  spec.version       = BlockParty::VERSION
  spec.authors       = ["Christopher Keele"]
  spec.email         = ["dev@chriskeele.com"]
  spec.summary       = "block_party-#{BlockParty::VERSION}"
  spec.description   = "Make any object configurable; quickly, cleanly, easily."
  spec.homepage      = "http://github.com/christhekeele/block_party"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^test\//)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",   "~> 1.3"
  spec.add_development_dependency "rake",      "> 10.0"
  spec.add_development_dependency "minitest",  ">  5.0"
  spec.add_development_dependency "simplecov", ">  0.7"
end
