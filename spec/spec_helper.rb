require "rspec"

if ENV["SIMPLECOV"]
  require "simplecov"
  SimpleCov.start do
    enable_coverage :branch
    add_filter "/spec/"
  end

  SimpleCov.minimum_coverage line: 100, branch: 100
end

gem_root = File.expand_path("..", __dir__)
require File.join(gem_root, "lib", "rspec", "exit_guard")

support_glob = File.join(gem_root, "spec", "support", "**", "*.rb")
Dir[support_glob].sort.each { |f| require f }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.mock_with :rspec
  config.order = "random"
  config.tty = true
  config.pattern = "spec/rspec/**{,/*/**}/*_spec.rb"
end
