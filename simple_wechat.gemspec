# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_wechat/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_wechat"
  spec.version       = SimpleWechat::VERSION
  spec.authors       = ["Yuan Cheung"]
  spec.email         = ["advanimal@gmail.com"]
  spec.summary       = %q{Simple WeChat API wrapper}
  spec.homepage      = "https://github.com/zhangyuan/wechat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 0.9"
  spec.add_runtime_dependency "multi_json", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.18"
end
