# frozen_string_literal: true

require_relative "lib/dev_orbit/version"

Gem::Specification.new do |spec|
  spec.name          = "dev_orbit"
  spec.version       = DevOrbit::VERSION
  spec.authors       = ["Orbit DevRel", "Ben Greenberg"]
  spec.email         = ["devrel@orbit.love"]

  spec.summary       = "Integrate DEV interactions into your Orbit workspace"
  spec.description   = "This gem integrates DEV blog interactions like comments, etc. into your Orbit workspace"
  spec.homepage      = "https://github.com/orbit-love/community-ruby-dev-orbit"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/orbit-love/community-ruby-dev-orbit"
  spec.metadata["changelog_uri"] = "https://github.com/orbit-love/community-ruby-dev-orbit/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "activesupport", "~> 6.1"
  spec.add_dependency "actionview", "~> 6.1"
  spec.add_dependency "http", "~> 4.4"
  spec.add_dependency "json", "~> 2.5"
  spec.add_dependency "zeitwerk", "~> 2.4"
  spec.add_dependency "thor", "~> 1.1"
  spec.add_dependency "orbit_activities", "~> 0.1"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "webmock", "~> 3.12"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
