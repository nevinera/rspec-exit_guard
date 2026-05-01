require "spec_helper"

RSpec.describe RSpec::NoWayOut do
  it "has a version" do
    expect(described_class::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
