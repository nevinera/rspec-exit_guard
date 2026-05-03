require "spec_helper"

RSpec.describe RSpec::NoWayOut::Helpers do
  describe "#catch_no_way_out_throw" do
    it "runs the block" do
      ran = false
      catch_no_way_out_throw { ran = true }
      expect(ran).to be(true)
    end

    it "raises ExitCalled when :no_way_out is thrown" do
      expect {
        catch_no_way_out_throw { throw :no_way_out, {method: :exit, code: 0, location: "f.rb:1"} }
      }.to raise_error(RSpec::NoWayOut::ExitCalled)
    end

    it "includes the method call and code in the message" do
      expect {
        catch_no_way_out_throw { throw :no_way_out, {method: :exit, code: 42, location: "f.rb:1"} }
      }.to raise_error(RSpec::NoWayOut::ExitCalled, /exit\(42\)/)
    end

    it "includes the call location in the message" do
      expect {
        catch_no_way_out_throw { throw :no_way_out, {method: :exit, code: 0, location: "foo/bar.rb:99"} }
      }.to raise_error(RSpec::NoWayOut::ExitCalled, /foo\/bar\.rb:99/)
    end
  end

  describe "#mock_exit_call_for_no_way_out" do
    let(:dummy_class) do
      Class.new do
        def quack(code = 0)
        end
      end
    end

    it "makes the target method throw :no_way_out with exit data" do
      mock_exit_call_for_no_way_out(dummy_class, :quack)
      result = catch(:no_way_out) { dummy_class.new.quack(42) }
      expect(result).to include(method: :quack, code: 42)
    end

    it "includes the call location in the thrown data" do
      mock_exit_call_for_no_way_out(dummy_class, :quack)
      result = catch(:no_way_out) { dummy_class.new.quack }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end
end
