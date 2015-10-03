# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["why404","BluntBlade", "bailong"]
  gem.email         = ["sdk@qiniu.com"]
  gem.description   = %q{Qiniu Resource (Cloud) Storage SDK for Ruby. See: http://developer.qiniu.com/docs/v6/sdk/ruby-sdk.html}
  gem.summary       = %q{Qiniu Resource (Cloud) Storage SDK for Ruby}
  gem.homepage      = "https://github.com/qiniu/ruby-sdk"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "qiniu"
  gem.require_paths = ["lib"]
  gem.version       = "7.0"
  gem.license       = "MIT"

  # specify any dependencies here; for example:
  gem.add_runtime_dependency "rest-client", "~> 1.8"
  gem.add_runtime_dependency "jruby-openssl", "~> 0.7" if RUBY_PLATFORM == "java"
end
