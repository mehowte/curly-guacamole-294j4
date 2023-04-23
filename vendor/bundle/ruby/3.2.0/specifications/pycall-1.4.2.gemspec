# -*- encoding: utf-8 -*-
# stub: pycall 1.4.2 ruby lib
# stub: ext/pycall/extconf.rb

Gem::Specification.new do |s|
  s.name = "pycall".freeze
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kenta Murata".freeze]
  s.bindir = "exe".freeze
  s.date = "2023-01-08"
  s.description = "pycall".freeze
  s.email = ["mrkn@mrkn.jp".freeze]
  s.extensions = ["ext/pycall/extconf.rb".freeze]
  s.files = ["ext/pycall/extconf.rb".freeze]
  s.homepage = "https://github.com/mrkn/pycall".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "pycall".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake-compiler-dock>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<launchy>.freeze, [">= 0"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
end
