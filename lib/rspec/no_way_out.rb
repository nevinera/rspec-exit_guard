require_relative "no_way_out/version"

module RSpec
  module NoWayOut
    ExitCalled = Class.new(StandardError)

    module Helpers
      def mock_exit_call_for_no_way_out(target, method_name)
        allow_any_instance_of(target).to receive(method_name) do |_obj, code = 0|
          location = caller.find { |l| !l.include?("/gems/") }
          throw :no_way_out, {method: method_name, code: code, location: location}
        end
      end

      def catch_no_way_out_throw
        exit_call = catch(:no_way_out) do
          yield
          nil
        end
        return unless exit_call

        raise RSpec::NoWayOut::ExitCalled,
          "#{exit_call[:method]}(#{exit_call[:code]}) called at #{exit_call[:location]}"
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
  end
end
