require "spec_helper"

RSpec.describe RSpec::ExitGuard::Helpers do
  describe "#catch_exit_guard_throw" do
    it "runs the block" do
      ran = false
      catch_exit_guard_throw { ran = true }
      expect(ran).to be(true)
    end

    it "raises ExitCalled when :exit_guard is thrown" do
      expect {
        catch_exit_guard_throw { throw :exit_guard, {call: "exit(0)", location: "f.rb:1"} }
      }.to raise_error(RSpec::ExitGuard::ExitCalled)
    end

    it "includes the call string in the message" do
      expect {
        catch_exit_guard_throw { throw :exit_guard, {call: "exit(42)", location: "f.rb:1"} }
      }.to raise_error(RSpec::ExitGuard::ExitCalled, /exit\(42\)/)
    end

    it "includes the call location in the message" do
      expect {
        catch_exit_guard_throw { throw :exit_guard, {call: "exit(0)", location: "foo/bar.rb:99"} }
      }.to raise_error(RSpec::ExitGuard::ExitCalled, /foo\/bar\.rb:99/)
    end
  end

  describe "#mock_exit_call_for_exit_guard" do
    let(:dummy_class) do
      Class.new do
        def quack(code = 0)
        end
      end
    end

    it "makes the target method throw :exit_guard with a formatted call string" do
      mock_exit_call_for_exit_guard(dummy_class, :quack)
      result = catch(:exit_guard) { dummy_class.new.quack(42) }
      expect(result[:call]).to eq("quack(42)")
    end

    it "includes the call location in the thrown data" do
      mock_exit_call_for_exit_guard(dummy_class, :quack)
      result = catch(:exit_guard) { dummy_class.new.quack }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_call_for_exit_guard with :abort" do
    # mock_exit_call_for_exit_guard(Object, :abort) is already active via the before hook,
    # so we call abort directly and rely on the inner catch to intercept the throw.

    it "throws :exit_guard with 'abort (no args)' when called without a message" do
      result = catch(:exit_guard) { abort }
      expect(result[:call]).to eq("abort (no args)")
    end

    it "includes the message when called with a short message" do
      result = catch(:exit_guard) { abort("something went wrong") }
      expect(result[:call]).to eq('abort("something went wrong")')
    end

    it "truncates long messages to 40 characters" do
      result = catch(:exit_guard) { abort("a" * 60) }
      expect(result[:call]).to eq("abort(\"#{"a" * 40}...\")")
    end

    it "includes the call location in the thrown data" do
      result = catch(:exit_guard) { abort }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Kernel.exit" do
    # mock_exit_module_call_for_exit_guard(Kernel, :exit) is already active via the before hook,
    # so we call Kernel.exit directly and rely on the inner catch to intercept the throw.

    it "throws :exit_guard with a formatted call string" do
      result = catch(:exit_guard) { Kernel.exit(42) }
      expect(result[:call]).to eq("exit(42)")
    end

    it "throws :exit_guard with 'exit (no args)' when called without an argument" do
      result = catch(:exit_guard) { Kernel.exit }
      expect(result[:call]).to eq("exit (no args)")
    end

    it "includes the call location in the thrown data" do
      result = catch(:exit_guard) { Kernel.exit(0) }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Kernel.exit!" do
    # mock_exit_module_call_for_exit_guard(Kernel, :exit!) is already active via the before hook.

    it "throws :exit_guard with a formatted call string" do
      result = catch(:exit_guard) { Kernel.exit!(1) }
      expect(result[:call]).to eq("exit!(1)")
    end

    it "includes the call location in the thrown data" do
      result = catch(:exit_guard) { Kernel.exit!(0) }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Process.exit" do
    # mock_exit_module_call_for_exit_guard(Process, :exit) is already active via the before hook.

    it "throws :exit_guard with a formatted call string" do
      result = catch(:exit_guard) { Process.exit(42) }
      expect(result[:call]).to eq("exit(42)")
    end

    it "includes the call location in the thrown data" do
      result = catch(:exit_guard) { Process.exit(0) }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Process.exit!" do
    # mock_exit_module_call_for_exit_guard(Process, :exit!) is already active via the before hook.

    it "throws :exit_guard with a formatted call string" do
      result = catch(:exit_guard) { Process.exit!(1) }
      expect(result[:call]).to eq("exit!(1)")
    end

    it "includes the call location in the thrown data" do
      result = catch(:exit_guard) { Process.exit!(0) }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Kernel.abort" do
    # mock_exit_module_call_for_exit_guard(Kernel, :abort) is already active via the before hook.

    it "throws :exit_guard with 'abort (no args)' when called without a message" do
      result = catch(:exit_guard) { Kernel.abort }
      expect(result[:call]).to eq("abort (no args)")
    end

    it "includes the message when called with a short message" do
      result = catch(:exit_guard) { Kernel.abort("something went wrong") }
      expect(result[:call]).to eq('abort("something went wrong")')
    end

    it "includes the call location in the thrown data" do
      result = catch(:exit_guard) { Kernel.abort }
      expect(result[:location]).to include("helpers_spec.rb")
    end
  end
end
