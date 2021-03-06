# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/verify_ipa/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-verify_ipa'
  spec.version       = Fastlane::VerifyIpa::VERSION
  spec.author        = 'Derek Yang'
  spec.email         = 'yanghada@gmail.com'

  spec.summary       = 'Verify various aspects of iOS ipa file'
  spec.homepage      = "https://github.com/dyang/verify_ipa"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w[README.md LICENSE]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'plist'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.18.2'
end
