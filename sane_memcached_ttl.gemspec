# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sane_memcached_ttl/version'

Gem::Specification.new do |spec|
  spec.name          = 'sane_memcached_ttl'
  spec.version       = SaneMemcachedTtl::VERSION
  spec.authors       = ['Errikos Koen']
  spec.email         = ['eirc.eric@gmail.com']
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'activesupport'

  # Cache stores
  spec.add_development_dependency 'couchbase'
  spec.add_development_dependency 'dalli', '< 2.7.1'

  # Testing gems
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
end
