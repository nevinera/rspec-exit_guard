require "rspec/no_way_out"

RSpec.describe "abort protection" do
  it "calls abort" do
    abort("something went wrong")
  end

  it "runs after the abort" do
    expect(1 + 1).to eq(2)
  end
end
