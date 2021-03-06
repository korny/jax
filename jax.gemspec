# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jax/version"

Gem::Specification.new do |s|
  s.name        = "jax"
  s.version     = Jax::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = "http://jaxgl.com"
  s.summary     = %q{Framework for creating rich WebGL-enabled applications using JavaScript and Ruby}
  s.description = %q{Framework for creating rich WebGL-enabled applications using JavaScript and Ruby}

  s.add_dependency 'rake',          '~> 0.8.7'
  s.add_dependency 'bundler',       '~> 1.0.14'
  s.add_dependency "thor",          '~> 0.14.6'
  s.add_dependency 'jasmine',       '~> 1.0.2.0'
  s.add_dependency 'activesupport', '~> 3.0'
  s.add_dependency "i18n",          '~> 0.5.0' # FIXME Jax doesn't really require this but ActiveSupport won't load without it!
  s.add_dependency 'sprockets',     '~> 1.0.2'
  
  s.add_development_dependency 'rspec',     '~> 2.0'
  s.add_development_dependency 'coderay',   '~> 0.9.7'
  
  # required by guides
  s.add_development_dependency 'actionpack',     '~> 3.0'
  s.add_development_dependency 'RedCloth',       '~> 4.2'
  s.add_development_dependency 'w3c_validators', '~> 1.1.1'

  # required by pdoc
  s.add_development_dependency 'treetop',   '~> 1.4.9'
  s.add_development_dependency 'bluecloth', '~> 2.0.11'

  s.rubyforge_project = "jax"

  # Don't include stuff used to build & document jax, the dist file is already built.
  useless_files = `git ls-files -- public/* guides/* vendor/* src/* dist/* spec/example_app/* spec/*.js`.split("\n")
  
  s.files         = `git ls-files`.split("\n") - useless_files
#                    `git ls-files -- spec/example_app/* public/images/*`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n") - useless_files
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
