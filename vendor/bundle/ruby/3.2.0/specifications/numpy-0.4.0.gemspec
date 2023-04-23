# -*- encoding: utf-8 -*-
# stub: numpy 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "numpy".freeze
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kenta Murata".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-06-21"
  s.description = "Numpy wrapper for Ruby".freeze
  s.email = ["mrkn@mrkn.jp".freeze]
  s.homepage = "https://github.com/mrkn/numpy.rb".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Numpy wrapper for Ruby".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<pycall>.freeze, [">= 1.2.0.beta1"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
  s.add_development_dependency(%q<numo-narray>.freeze, [">= 0"])
end
