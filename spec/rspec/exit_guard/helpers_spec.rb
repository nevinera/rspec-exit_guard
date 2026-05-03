require "spec_helper"

RSpec.describe RSpec::ExitGuard::Helpers do
  describe "#mock_exit_call_for_exit_guard" do
    let(:dummy_class) do
      Class.new do
        def quack(code = 0)
        end
      end
    end

    it "raises ExitCalled with a formatted call string" do
      mock_exit_call_for_exit_guard(dummy_class, :quack)
      expect { dummy_class.new.quack(42) }.to raise_error(RSpec::ExitGuard::ExitCalled, /quack\(42\)/)
    end

    it "includes the call location in the raised error" do
      mock_exit_call_for_exit_guard(dummy_class, :quack)
      expect { dummy_class.new.quack }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end

  describe "#mock_exit_call_for_exit_guard with :abort" do
    # mock_exit_call_for_exit_guard(Object, :abort) is already active via the before hook,
    # so we call abort directly.

    it "raises ExitCalled with 'abort (no args)' when called without a message" do
      expect { abort }.to raise_error(RSpec::ExitGuard::ExitCalled, /abort \(no args\)/)
    end

    it "includes the message when called with a short message" do
      expect { abort("something went wrong") }.to raise_error(RSpec::ExitGuard::ExitCalled, /abort\("something went wrong"\)/)
    end

    it "truncates long messages to 40 characters" do
      expect { abort("a" * 60) }.to raise_error(RSpec::ExitGuard::ExitCalled, /abort\("#{"a" * 40}\.\.\."\)/)
    end

    it "includes the call location in the raised error" do
      expect { abort }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Kernel.exit" do
    # mock_exit_module_call_for_exit_guard(Kernel, :exit) is already active via the before hook.

    it "raises ExitCalled with a formatted call string" do
      expect { Kernel.exit(42) }.to raise_error(RSpec::ExitGuard::ExitCalled, /exit\(42\)/)
    end

    it "raises ExitCalled with 'exit (no args)' when called without an argument" do
      expect { Kernel.exit }.to raise_error(RSpec::ExitGuard::ExitCalled, /exit \(no args\)/)
    end

    it "includes the call location in the raised error" do
      expect { Kernel.exit(0) }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Kernel.exit!" do
    # mock_exit_module_call_for_exit_guard(Kernel, :exit!) is already active via the before hook.

    it "raises ExitCalled with a formatted call string" do
      expect { Kernel.exit!(1) }.to raise_error(RSpec::ExitGuard::ExitCalled, /exit!\(1\)/)
    end

    it "includes the call location in the raised error" do
      expect { Kernel.exit!(0) }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Process.exit" do
    # mock_exit_module_call_for_exit_guard(Process, :exit) is already active via the before hook.

    it "raises ExitCalled with a formatted call string" do
      expect { Process.exit(42) }.to raise_error(RSpec::ExitGuard::ExitCalled, /exit\(42\)/)
    end

    it "includes the call location in the raised error" do
      expect { Process.exit(0) }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Process.exit!" do
    # mock_exit_module_call_for_exit_guard(Process, :exit!) is already active via the before hook.

    it "raises ExitCalled with a formatted call string" do
      expect { Process.exit!(1) }.to raise_error(RSpec::ExitGuard::ExitCalled, /exit!\(1\)/)
    end

    it "includes the call location in the raised error" do
      expect { Process.exit!(0) }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end

  describe "#mock_exit_module_call_for_exit_guard with Kernel.abort" do
    # mock_exit_module_call_for_exit_guard(Kernel, :abort) is already active via the before hook.

    it "raises ExitCalled with 'abort (no args)' when called without a message" do
      expect { Kernel.abort }.to raise_error(RSpec::ExitGuard::ExitCalled, /abort \(no args\)/)
    end

    it "includes the message when called with a short message" do
      expect { Kernel.abort("something went wrong") }.to raise_error(RSpec::ExitGuard::ExitCalled, /abort\("something went wrong"\)/)
    end

    it "includes the call location in the raised error" do
      expect { Kernel.abort }.to raise_error(RSpec::ExitGuard::ExitCalled, /helpers_spec\.rb/)
    end
  end
end
