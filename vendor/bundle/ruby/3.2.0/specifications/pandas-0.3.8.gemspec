# -*- encoding: utf-8 -*-
# stub: pandas 0.3.8 ruby lib

Gem::Specification.new do |s|
  s.name = "pandas".freeze
  s.version = "0.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kenta Murata".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-07-12"
  s.description = "Pandas wrapper for Ruby".freeze
  s.email = ["mrkn@mrkn.jp".freeze]
  s.homepage = "https://github.com/mrkn/pandas.rb".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Pandas wrapper for Ruby".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<pycall>.freeze, [">= 1.0.0"])
  s.add_runtime_dependency(%q<numpy>.freeze, [">= 0"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.17.2"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<activerecord>.freeze, [">= 4.2"])
  s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
end
