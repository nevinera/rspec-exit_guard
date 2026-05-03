require "spec_helper"

RSpec.describe RSpec::NoWayOut do
  it "has a version" do
    expect(described_class::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end

  describe "without the plugin, when exit(0) is called from code under test" do
    let(:result) { run_fixture("exit_zero_spec.rb") }
    let(:output) { result[0] }
    let(:exit_code) { result[1] }

    it "silently succeeds" do
      expect(exit_code).to eq(0)
    end

    it "only runs the first example" do
      expect(output).to include("1 example, 0 failures")
    end
  end

  describe "with the plugin, when exit(0) is called from code under test" do
    let(:result) { run_fixture("exit_zero_with_no_way_out_spec.rb") }
    let(:output) { result[0] }
    let(:exit_code) { result[1] }

    it "does not silently succeed" do
      expect(exit_code).not_to eq(0)
    end

    it "reports the exit as a failure" do
      expect(output).to include("1 failure")
    end

    it "includes the exit code in the failure message" do
      expect(output).to include("exit(0)")
    end

    it "includes the call site in the failure message" do
      expect(output).to include("exit_zero_with_no_way_out_spec.rb")
    end

    it "still runs the subsequent example" do
      expect(output).to include("2 examples")
    end
  end
end
