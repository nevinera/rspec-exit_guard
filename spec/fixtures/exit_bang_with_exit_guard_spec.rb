require "rspec/exit_guard"

RSpec.describe "exit! protection" do
  it "calls exit!(1)" do
    exit!(1)
  end

  it "runs after the exit!" do
    expect(1 + 1).to eq(2)
  end
end
