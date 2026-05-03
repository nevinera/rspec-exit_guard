require_relative "no_way_out/version"

module RSpec
  module NoWayOut
    ExitCalled = Class.new(StandardError)

    module Helpers
      def mock_exit_call_for_no_way_out(target, method_name)
        allow_any_instance_of(target).to receive(method_name) do |_obj, *args|
          location = caller.find { |l| !l.include?("/gems/") }
          throw :no_way_out, {call: no_way_out_call_string(method_name, args), location: location}
        end
      end

      def catch_no_way_out_throw
        exit_call = catch(:no_way_out) do
          yield
          nil
        end
        return unless exit_call

        raise RSpec::NoWayOut::ExitCalled,
          "#{exit_call[:call]} called at #{exit_call[:location]}"
      end

      private

      def no_way_out_call_string(method_name, args)
        return "#{method_name} (no args)" if args.empty?

        arg = args.first
        formatted = arg.is_a?(String) ? no_way_out_truncate(arg, 40).inspect : arg
        "#{method_name}(#{formatted})"
      end

      def no_way_out_truncate(str, max_length)
        return str if str.length <= max_length

        "#{str[0, max_length]}..."
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::NoWayOut::Helpers

  config.around(:each) do |example|
    catch_no_way_out_throw { example.run }
  end

  config.before(:each) do
    mock_exit_call_for_no_way_out(Object, :exit)
    mock_exit_call_for_no_way_out(Object, :exit!)
    mock_exit_call_for_no_way_out(Object, :abort)
  end
end
