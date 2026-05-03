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
        catch_no_way_out_throw { throw :no_way_out, {call: "exit(0)", location: "f.rb:1"} }
      }.to raise_error(RSpec::NoWayOut::ExitCalled)
    end

    it "includes the call string in the message" do
      expect {
        catch_no_way_out_throw { throw :no_way_out, {call: "exit(42)", location: "f.rb:1"} }
      }.to raise_error(RSpec::NoWayOut::ExitCalled, /exit\(42\)/)
    end

    it "includes the call location in the message" do
      expect {
        catch_no_way_out_throw { throw :no_way_out, {call: "exit(0)", location: "foo/bar.rb:99"} }
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

    it "makes the target method throw :no_way_out with a formatted call string" do
      mock_exit_call_for_no_way_out(dummy_class, :quack)
      result = catch(:no_way_out) { dummy_class.new.quack(42) }
      expect(result[:call]).to eq("quack(42)")
    end

    it "includes the call location in the thrown data" do
      mock_exit_call_for_no_way_out(dummy_class, :quack)
      result = catch(:no_way_out) { dummy_class.new.quack }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_call_for_no_way_out with :abort" do
    # mock_exit_call_for_no_way_out(Object, :abort) is already active via the before hook,
    # so we call abort directly and rely on the inner catch to intercept the throw.

    it "throws :no_way_out with 'abort (no args)' when called without a message" do
      result = catch(:no_way_out) { abort }
      expect(result[:call]).to eq("abort (no args)")
    end

    it "includes the message when called with a short message" do
      result = catch(:no_way_out) { abort("something went wrong") }
      expect(result[:call]).to eq('abort("something went wrong")')
    end

    it "truncates long messages to 40 characters" do
      result = catch(:no_way_out) { abort("a" * 60) }
      expect(result[:call]).to eq("abort(\"#{"a" * 40}...\")")
    end

    it "includes the call location in the thrown data" do
      result = catch(:no_way_out) { abort }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end
end
