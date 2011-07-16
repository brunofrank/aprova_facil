# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'aprova_facil/version'

Gem::Specification.new do |s|
  s.name        = "aprova_facil"
  s.version     = AprovaFacil::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bruno Frank"]
  s.email       = ["bfscordeiro@gmail.com"]
  s.homepage    = "https://github.com/brunofrank/aprova_facil"
  s.summary     = %q{Gem para integração de aplicação Ruby com o gateway de pagamento Aprova Fácil da Cobre Bem.}
  s.description = %q{Gem para integração de aplicação Ruby com o gateway de pagamento Aprova Fácil da Cobre Bem.}

  s.rubyforge_project = "aprova_facil"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end