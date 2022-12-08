# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "elixir-toolkit-theme-plugins"
  spec.version       = "0.1.0"
  spec.authors       = ["bedroesb"]
  spec.email         = ["bedro@psb.vib-ugent.be\n"]

  spec.summary       = "Plugins to work together with ELIXIR Toolkit theme"
  spec.homepage      = "https://elixir-belgium.github.io/elixir-toolkit-theme-plugins/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_plugins|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 4.3.1"

  spec.add_development_dependency "bundler", ">= 2.2.16"
  spec.add_development_dependency "rake", "~> 12.0"
end
