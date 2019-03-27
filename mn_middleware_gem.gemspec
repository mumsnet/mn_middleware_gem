
# lib = File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require "mn_middleware_gem/version"
#
Gem::Specification.new do |spec|
  spec.name          = "mn_middleware_gem"
  spec.version       = "1.4.1"
  spec.authors       = ["Shamim Mirzai"]
  spec.summary       = "Mumsnet middleware gem for microservices"
  spec.homepage      = "https://github.com/mumsnet/mn_middleware_gem"

  # Specify which files should be added to the gem when it is released.
  spec.files         = [
    'lib/mn_middleware_gem.rb',
    'lib/mn_middleware_gem/version.rb',
    'lib/mn_middleware_gem/mn_middleware/correlation_id.rb',
    'lib/mn_middleware_gem/mn_middleware/remote_ip_logger.rb'
  ]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'request_store'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
