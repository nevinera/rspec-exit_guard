require_relative "lib/rspec/exit_guard/version"

Gem::Specification.new do |spec|
  spec.name = "rspec-exit_guard"
  spec.version = RSpec::ExitGuard::VERSION
  spec.authors = ["Eric Mueller"]
  spec.email = ["nevinera@gmail.com"]

  spec.summary = "Protect your RSpec suite from exit calls in code under test"
  spec.description = <<~DESC
    rspec-exit_guard guards your test suite against accidental termination caused
    by exit, abort, or similar calls in the code under test. Instead of letting
    the process exit (potentially silently, with a passing status), it catches
    those calls and turns them into test failures.
  DESC

  spec.homepage = "https://github.com/nevinera/rspec-exit_guard"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.start_with?("spec") }
      .reject { |f| f.start_with?("Gemfile") }
  end

  spec.bindir = "bin"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 3.10"

  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "pry", "~> 0.15"
  spec.add_development_dependency "standard", "= 1.37.0"
  spec.add_development_dependency "rubocop", "~> 1.63"
  spec.add_development_dependency "quiet_quality", "~> 1.5"
  spec.add_development_dependency "mdl", "~> 0.13"
end
