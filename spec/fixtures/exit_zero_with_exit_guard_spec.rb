require "rspec/exit_guard"

RSpec.describe "exit protection" do
  it "calls exit(0)" do
    exit(0)
  end

  it "runs after the exit" do
    expect(1 + 1).to eq(2)
  end
end
