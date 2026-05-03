require_relative "exit_guard/version"

module RSpec
  module ExitGuard
    ExitCalled = Class.new(Exception)

    module Helpers
      def mock_exit_call_for_exit_guard(target, method_name)
        allow_any_instance_of(target).to receive(method_name) do |_obj, *args|
          location = caller.find { |l| !l.include?("/gems/") }
          raise RSpec::ExitGuard::ExitCalled, "#{exit_guard_call_string(method_name, args)} called at #{location}"
        end
      end

      def mock_exit_module_call_for_exit_guard(target, method_name)
        allow(target).to receive(method_name) do |*args|
          location = caller.find { |l| !l.include?("/gems/") }
          raise RSpec::ExitGuard::ExitCalled, "#{exit_guard_call_string(method_name, args)} called at #{location}"
        end
      end

      private

      def exit_guard_call_string(method_name, args)
        return "#{method_name} (no args)" if args.empty?

        arg = args.first
        formatted = arg.is_a?(String) ? exit_guard_truncate(arg, 40).inspect : arg
        "#{method_name}(#{formatted})"
      end

      def exit_guard_truncate(str, max_length)
        return str if str.length <= max_length

        "#{str[0, max_length]}..."
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::ExitGuard::Helpers

  config.before(:each) do
    mock_exit_call_for_exit_guard(Object, :exit)
    mock_exit_call_for_exit_guard(Object, :exit!)
    mock_exit_call_for_exit_guard(Object, :abort)
    mock_exit_module_call_for_exit_guard(Kernel, :exit)
    mock_exit_module_call_for_exit_guard(Kernel, :exit!)
    mock_exit_module_call_for_exit_guard(Kernel, :abort)
    mock_exit_module_call_for_exit_guard(Process, :exit)
    mock_exit_module_call_for_exit_guard(Process, :exit!)
  end
end
