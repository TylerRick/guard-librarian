# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/librarian/version'

Gem::Specification.new do |s|
  s.name        = 'guard-librarian'
  s.version     = Guard::LibrarianVersion::Version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Yann Lugrin', 'Tyler Rick']
  s.email       = ['yann.lugrin@sans-savoir.net', 'tyler@k3integrations.com']
  s.homepage    = 'http://rubygems.org/gems/guard-librarian'
  s.summary     = 'Guard gem for Librarian'
  s.description = 'Guard::Librarian automatically installs your cookbook dependencies from your Cheffile using librarian-chef when needed'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_dependency 'guard',   '>= 0.2.2'
  s.add_dependency 'librarian'

  s.add_development_dependency 'rspec',       '~> 2.6.0'
  s.add_development_dependency 'guard-rspec', '~> 0.3.1'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'

  s.rdoc_options = ["--charset=UTF-8", "--main=README.rdoc", "--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'"]
end
