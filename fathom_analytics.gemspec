require_relative 'lib/fathom_analytics/version'

Gem::Specification.new do |spec|
  spec.name          = "fathom_analytics"
  spec.version       = FathomAnalytics::VERSION
  spec.authors       = ["Sunny Rana"]
  spec.email         = ["gpoisoned@gmail.com"]

  spec.summary       = %q{Ruby client for Fathom Analytics server.}
  spec.homepage      = "https://github.com/gpoisoned/fathom_analytics"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gpoisoned/fathom_analytics"
  spec.metadata["changelog_uri"] = "https://github.com/gpoisoned/fathom_analytics"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '~> 1.0', '>= 1.0.1'

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0' 
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry-byebug"
end