# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "qiniu/version"

Gem::Specification.new do |s|
  s.name          = "qiniu"
  s.version       = Qiniu::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = ['MIT']
  s.email         = ["sdk@qiniu.com"]
  s.summary       = %q{Qiniu Resource (Cloud) Storage SDK for Ruby}
  s.description   = %q{Qiniu Resource (Cloud) Storage SDK for Ruby. See: http://developer.qiniu.com/docs/v7/sdk/ruby-sdk.html}
  s.homepage      = "https://github.com/qiniu/ruby-sdk"
  s.authors       = ["why404", "BluntBlade", "bailong"]

  s.required_ruby_version     = '>= 1.9.3'

  s.add_runtime_dependency "rest-client", ">= 1.7"
  s.add_runtime_dependency "jruby-openssl", ">= 0.7" if RUBY_PLATFORM == "java"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]
end
