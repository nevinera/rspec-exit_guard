require "open3"

module SubprocessHelper
  FIXTURES_DIR = File.expand_path("../fixtures", __dir__)

  def run_fixture(name)
    path = File.join(FIXTURES_DIR, name)
    output, status = Open3.capture2e("bundle exec rspec --options /dev/null -Ilib #{path}")
    [output, status.exitstatus]
  end
end

RSpec.configure do |config|
  config.include SubprocessHelper
end
