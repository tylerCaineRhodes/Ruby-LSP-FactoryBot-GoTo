# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "ruby-lsp-factory_bot-goto"
  spec.version = "0.1.0"
  spec.authors = ["Tyler Rhodes"]
  spec.email = ["tyler.rhodes@aya.yale.edu"]

  spec.summary = "Ruby LSP addon for FactoryBot go-to-definition support"
  spec.description = "Provides 'Go to Definition' functionality for FactoryBot factories in Ruby LSP. Jump from factory references like create(:user) directly to factory definitions."
  spec.homepage = "https://github.com/tylercainerhodes/ruby-lsp-factory_bot-goto"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob([
    "lib/**/*.rb",
    "LICENSE.txt",
    "README.md",
    "CHANGELOG.md"
  ])
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "prism", "~> 0.19"
  spec.add_dependency "ruby-lsp", "~> 0.26"
end
